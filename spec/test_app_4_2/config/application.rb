require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module TestApp42
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
  end
end

