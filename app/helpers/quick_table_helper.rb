module QuickTableHelper
  def quick_table(*args, &block)
    QuickTable.generate(*args, &block)
  end
end
