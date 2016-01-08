class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # helper :quick_table
  # include QuickTableHelper
  # helper QuickTable::Application.helpers

  # helper QuickTable::QuickTableHelper
  # helper QuickTable::Engine.helpers
end
