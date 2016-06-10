module QuickTableHelper
  def quick_table(*args, &block)
    QuickTable::Htmlizer.generate(*args, &block)
  end
end
