require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module TestApp40
  class Application < Rails::Application
  end
end

