module QuickTableHelper
  def quick_table(*args, &block)
    QuickTable::Base.generate(*args, &block)
  end
end
