module QuickTableHelper
  def quick_table(*args, &block)
    QuickTable::Htmlizer.htmlize(self, *args, &block)
  end
end
