# frozen_string_literal: true
require 'olive_branch/checks'
require 'olive_branch/transformations'

# Basic configuration
module OliveBranch
  class Configuration
    attr_accessor :camelize, :dasherize, :content_type_check, :default_inflection, :header_key

    def initialize
      @camelize = Transformations.method(:camelize)
      @dasherize = Transformations.method(:dasherize)
      @content_type_check = Checks.method(:content_type_check)
      @header_key = 'HTTP_X_KEY_INFLECTION'.freeze
    end
  end
end
