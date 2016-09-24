require "active_support/core_ext/kernel/concern"

module QuickTable
  concern :ActiveRecord do
    class_methods do
      def to_quick_table(**options)
        QuickTable.generate(all.collect(&:attributes), options)
      end
    end

    def to_quick_table(**options)
      QuickTable.generate(attributes, options)
    end
  end
end

Kernel.class_eval do
  private

  def quick_table(*args, &block)
    QuickTable.generate(*args, &block)
  end

  def qt(*args, &block)
    QuickTable.generate(*args, &block).display
  end
end

[Array, Hash, Symbol, String, Numeric].each do |e|
  e.class_eval do
    def to_quick_table(**options)
      QuickTable.generate(self, options)
    end
  end
end
