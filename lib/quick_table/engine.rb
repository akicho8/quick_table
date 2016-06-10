module QuickTable
  class Engine < Rails::Engine
    initializer "quick_table" do
      ActiveSupport.on_load(:active_record) do
        include QuickTable::ActiveRecord
      end
    end
  end
end
