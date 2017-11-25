# frozen_string_literal: true
require 'olive_branch/middleware'

module OliveBranch
  class Railtie < Rails::Railtie
    initializer 'olive_branch.configure_rails_initialization'.freeze do |app|
      app.middleware.use OliveBranch::Middleware
    end
  end
end
