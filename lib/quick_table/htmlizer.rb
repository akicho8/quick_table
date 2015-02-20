# -*- coding: utf-8 -*-
#
# オブジェクトをHTMLのテーブルにして出力
#
# 使い方:
#   1. ApplicationHelper 等で include QuickTable::Helpers
#   2. quick_table.css.scss を読み込む
#   3. ビューで <%= quick_table("ok") %>
#
# 仕様:
#   ・配列以外のオブジェクト or N次元配列を受けとれる
#   ・配列以外のオブジェクトは一つの要素だけを持った一次元配列と見なす
#   ・一次元配列は横に並べて表示する
#   ・二次元配列は縦に伸びる
#   ・三次元配列の場合はテーブルが入れ子になる
#   ・引数にハッシュを渡すとそれがオプションと解釈されてしまうので、ブロックで渡すこと
#   ・というかすべてブロックで渡した方がいい
#   ・出力用の変数の初期化をするのが面倒なのでブロックで空の配列を渡すようにしている
#   ・quick_table(:table_class => "x"){} でクラスを追加
#
# 実行例
#   quick_table
#     引数がないので何も表示しない
#
#   quick_table{:a}
#     [a]
#
#   quick_table(:a => 1)
#     [a][1]
#
#   quick_table({:a => 1}, :o => 1) # オプション {o => 1}
#     [a][1]
#
#   quick_table(:a)
#     [a]
#
#   quick_table{[:a, 1]}
#     [a][1]
#
#   quick_table{[:a, 1, :b, 2]}
#     [a][1][b][2]
#
#   quick_table{[[:a, 1], [:b, 2]]}
#     [a][1]
#     [b][2]
#
#   quick_table{{:a => 1, :b => 2}}
#     [a][1]
#     [b][2]
#
#   quick_table({:a => 1, :b => 2}.to_a)
#     [a][1]
#     [b][2]
#
#   quick_table{[[1,[2,3]], [[4,5],6]]}
#     [1][[2][3]]
#     [[4][5]][6]
#
#   quick_table{|items|
#     items << 1
#     items << 2
#     items << 3
#   }
#     [1][2][3]
#
#   quick_table(:a, :b, :o => 1) # オプション {:o => 1}
#     [a][b]
#
#   quick_table(:array_of_hash => true){[{:a => 1, :b => 2}, {:a => 3, :b => 4}]}
#     [a][b]
#     [1][2]
#     [3][4]
#
# 具体例
#
#   セッション内容表示
#   quick_table(session, :title => "セッション")
#
#   current_userの属性表示
#   quick_table(current_user.attributes, :title => "current_user")
#
#   セッションオプションの表示
#   quick_table(request.session_options, :title => "セッションオプション")
#   [secure][false]
#   [path  ][/    ]
#
#   paramsの内容表示
#   quick_table(params, :title => "Params")
#

module QuickTable
  class Htmlizer
    attr_accessor :view_context
    alias h view_context

    def self.htmlize(view_context, *args, &block)
      new(view_context).htmlize(*args, &block)
    end

    def initialize(view_context)
      @view_context = view_context
    end

    #
    # オブジェクトをHTMLのテーブルにして出力
    #
    def htmlize(*args, &block)
      if block_given?
        options = args.extract_options!
        stock = []
        object = yield stock
        object ||= stock       # yield の戻値を使うが、nil なら stock に入れられたものを使う(どちらかに決めた方がいいかも)
      else
        if args.size == 0
          return
        elsif args.size == 1
          object = args.first
          options = {}
        else
          options = args.extract_options!
          if args.size > 1
            object = args
          else
            object = args.first
          end
        end
      end

      if options[:array_of_hash] && object.kind_of?(Array) && object.first.kind_of?(Hash)
        #
        # ハッシュの配列ならBに変換
        #
        # A:   [{:a => 1, :b => 2},
        #       {:a => 2, :b => 3}],
        #
        # B:   [[:a, :b],
        #        [1, 2],
        #        [3, 4]],
        #
        object = [object.first.keys] + object.collect{|row|row.values}
      end

      return if object.blank?

      if object.is_a?(Hash)
        object = object.to_a
      end

      options[:depth] ||= 0

      object = Array.wrap(object)
      if object.first.is_a?(Array)
        # 要素が配列の場合
        content = object.collect {|records|
          tds = Array.wrap(records).collect do |record|
            # 要素が配列の配列
            if record.is_a? Array
              h.content_tag(:td, htmlize(record.inspect, :depth => options[:depth].next))
            else
              h.content_tag(:td, record.to_s.html_safe)
            end
          end
          h.content_tag(:tr, quick_table_join(tds))
        }.join
      else
        # 要素が配列以外の場合
        tds = object.collect do |record|
          h.content_tag(:td, record)
        end
        content = h.content_tag(:tr, tds.join.html_safe)
      end
      if options[:depth].zero?
        content = h.content_tag(:tbody, content.html_safe)
        # if options[:title].present?
        #   content = h.content_tag(:caption, options[:title].html_safe) + content.to_s.html_safe
        # end
      end
      # "table-condensed table-bordered table-striped"
      table_class = options[:table_class] # || "table-condensed table-bordered table-striped"
      content = h.content_tag(:table, content, :class => "table #{table_class}".strip)
      if options[:depth].zero?
        if options[:title].present?
          content = h.content_tag(:h2, options[:title].html_safe, :class => "title") + content.to_s.html_safe
        end
      end
      h.content_tag(:div, content, :class => "quick_table depth_#{options[:depth]}")
    end

    private

    def quick_table_join(elems)
      elems.join.html_safe
    end
  end
end
