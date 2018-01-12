require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module TestApp50
  class Application < Rails::Application
  end
end

