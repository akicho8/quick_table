module QuickTableHelper
  def quick_table(*args, &block)
    QuickTable::Htmlizer.htmlize(*args, &block)
  end
end
