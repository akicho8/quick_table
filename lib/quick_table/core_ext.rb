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
  def quick_table(object, **options)
    if object.respond_to?(:to_quick_table)
      object.to_quick_table(options)
    else
      QuickTable.generate(object, options)
    end
  end

  def qt(*args)
    quick_table(*args).display
  end
end

[Array, Hash, Symbol, String, Numeric].each do |e|
  e.class_eval do
    def to_quick_table(**options)
      QuickTable.generate(self, options)
    end
  end
end
