# frozen_string_literal: true

module OliveBranch
  class Railtie < Rails::Railtie
    initializer 'olive_branch.initialization' do |app|
      require 'olive_branch/middleware'
      app.middleware.use OliveBranch::Middleware
    end
  end
end
