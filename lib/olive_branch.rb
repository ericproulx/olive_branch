# frozen_string_literal: true
require 'olive_branch/middleware'
require 'olive_branch/configuration'
require 'olive_branch/railtie' if defined?(Rails)

# configuration
module OliveBranch
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def reset_configuration
      @configuration = Configuration.new
    end

    attr_writer :configuration

    def configure
      yield configuration
    end
  end
end
