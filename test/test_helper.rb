require "test/unit"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'quick_table'
require "#{__dir__}/../app/helpers/quick_table_helper"

require "rails"
require 'erb'
require 'cgi'
require 'active_support/core_ext/class/attribute_accessors'
require 'action_pack'
require 'action_view/helpers/capture_helper'
require 'action_view/helpers/sanitize_helper'
require 'action_view/helpers/output_safety_helper'
require 'action_view/helpers/url_helper'
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/text_helper'

class ViewContext
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::OutputSafetyHelper
  include QuickTableHelper
end
