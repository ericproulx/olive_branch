require 'olive_branch/middleware'

module OliveBranch
  class Railtie < Rails::Railtie
    initializer 'olive_branch.configure_rails_initialization' do |app|
      app.middleware.use OliveBranch::Middleware
    end
  end
end
