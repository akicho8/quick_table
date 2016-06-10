# -*- coding: utf-8 -*-
#
# オブジェクトをHTMLのテーブルにして出力
#

module QuickTable
  mattr_accessor :default_options
  self.default_options = {
    :table_class  => "",
    :nesting      => false,
    :title_tag    => :h2,

    :header_patch => true,     # ヘッダーがなければ追加する
    :key_label    => "Key",
    :value_label  => "Value",
  }

  class Htmlizer
    attr_accessor :view_context
    alias h view_context

    def self.htmlize(view_context, *args, &block)
      if block_given?
        obj = yield
        options = args.extract_options!
      else
        if args.size == 0
          return
        elsif args.size == 1
          obj = args.first
          options = {}
        else
          options = args.extract_options!
          if args.size > 1
            obj = args
          else
            obj = args.first
          end
        end
      end

      new(view_context, options).htmlize(obj)
    end

    def initialize(view_context, options)
      @view_context = view_context
      @options = QuickTable.default_options.merge(:depth => 0).merge(options)
    end

    def htmlize(obj)
      return if obj.blank?

      info = function_table.find { |e| e[:if].call(obj) }
      body = "".html_safe
      if true
        if @options[:caption].present?
          body << tag(:caption, @options[:caption])
        end
      end
      if @options[:header_patch]
        if info[:header_patch]
          if v = info[:header_patch].call(obj)
            body << v
          end
        end
      end
      body << info[:code].call(obj)
      body = tag(:table, body, :class => table_class(info))
      if @options[:depth].zero?
        if @options[:responsive]
          body = tag(:div, body, :class => "table-responsive")
        end
        if true
          if @options[:title].present?
            body = tag(@options[:title_tag], @options[:title], :class => "title") + body
          end
        end
      end
      tag(:div, body, :class => "quick_table quick_table_depth_#{@options[:depth]}")
    end

    private

    def function_table
      [
        # {:a => 1, :b => 2}
        # [a][1]
        # [b][2]
        {
          :if   => -> obj { obj.kind_of?(Hash) },
          :format_class => "qt_hash_only",
          :header_patch => -> obj {
            tag(:thead) do
              tr do
                th(@options[:key_label]) + th(@options[:value_label])
              end
            end
          },
          :code => -> obj {
            obj.collect {|key, val|
              tr do
                th(key) + td(val)
              end
            }.join.html_safe
          },
        },

        # [{:a => 1, :b => 2}, {:a => 3, :b => 4}]
        # [a][b]
        # [1][2]
        # [3][4]
        {
          :if   => -> obj { obj.kind_of?(Array) && obj.all?{|e|e.kind_of?(Hash)} },
          :format_class => "qt_array_of_hash",
          :code => -> obj {
            keys = obj.inject([]) { |a, e| a | e.keys }
            body = "".html_safe
            body += tag(:thead) do
              tr do
                keys.collect {|e| th(e) }.join.html_safe
              end
            end
            body + tag(:tbody) do
              obj.collect { |hash|
                tr do
                  keys.collect { |key| td(hash[key]) }.join.html_safe
                end
              }.join.html_safe
            end
          },
        },

        # [[:a, :b], [ 1,  2], [ 3,  4]]
        # [a][b]
        # [1][2]
        # [3][4]
        {
          :if   => -> obj { obj.kind_of?(Array) && obj.all?{|e|e.kind_of?(Array)} },
          :format_class => "qt_array_of_array",
          :header_patch => -> obj {
            if obj.first.kind_of?(Array)
              tag(:thead) do
                obj.first.collect { td("") }.join.html_safe # カラムの意味はわからないので空ラベルとする
              end
            end
          },
          :code => -> obj {
            tag(:tbody) do
              obj.collect { |elems|
                tr do
                  elems.collect { |e| td(e) }.join.html_safe
                end
              }.join.html_safe
            end
          },
        },

        # [:a, :b]
        # [a][b]
        {
          :if   => -> obj { obj.kind_of?(Array) },
          :format_class => "qt_array",
          :code => -> obj {
            tag(:tbody) do
              tr do
                obj.collect { |e| td(e) }.join.html_safe
              end
            end
          },
        },

        # :a
        # [a]
        {
          :if   => -> obj { true },
          :format_class => "qt_other",
          :code => -> obj {
            tag(:tbody) do
              tr { td(obj) }
            end
          },
        },
      ]
    end

    def tag(*args, &block)
      h.content_tag(*args, &block)
    end

    def tr(&block)
      tag(:tr, &block)
    end

    def th(val)
      tag(:th, val)
    end

    def td(val)
      tag(:td, value_as_string(val))
    end

    def value_as_string(val)
      if val.kind_of?(Array) || val.kind_of?(Hash)
        if @options[:nesting]
          self.class.htmlize(view_context, @options.merge(:depth => @options[:depth].next)) { val }
        else
          val
        end
      else
        val
      end
    end

    def table_class(info)
      if @options[:depth] == 0
        # return "table table-condensed table-bordered table-striped"
        "table #{@options[:table_class]} #{info[:format_class]}".squish.scan(/\S+/).uniq.join(" ")
      else
        # 入れ子になったテーブルは小さめにして装飾を避ける
        "table table-condensed"
      end
    end
  end
end
