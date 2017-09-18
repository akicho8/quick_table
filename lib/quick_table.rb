require "quick_table/quick_table"
require "quick_table/core_ext"
require "quick_table/engine" if defined?(Rails)
require "quick_table/version"

module QuickTable
end

ActiveSupport::Deprecation.warn("I do not maintain this library anymore. Please use html_format instead.")
