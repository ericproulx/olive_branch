require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module TestApp51
  class Application < Rails::Application
    config.load_defaults 5.1
  end
end

