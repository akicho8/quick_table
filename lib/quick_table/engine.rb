module QuickTable
  class Railtie < Rails::Railtie
    initializer "quick_table" do
      ActiveSupport.on_load(:active_record) do
        include QuickTable::ActiveRecord
      end
    end
  end
end
