require 'multi_json'
require 'olive_branch/checks'
require 'olive_branch/transformations'

module OliveBranch
  class Middleware
    attr_reader :camelize, :dasherize, :default_inflection, :content_type_check

    def initialize(app, args = {})
      @app = app
      @camelize = args.fetch(:camelize, Transformations.method(:camelize))
      @dasherize = args.fetch(:dasherize, Transformations.method(:dasherize))
      @content_type_check = args.fetch(:content_type_check, Checks.method(:content_type_check))
      @default_inflection = args[:inflection]
    end

    def call(env)
      dup._call env
    end

    def _call(env)
      inflection = env.fetch('HTTP_X_KEY_INFLECTION', default_inflection)
      Transformations.underscore_params(env) if inflection && content_type_check.call(env['CONTENT_TYPE'])

      @app.call(env).tap do |_status, headers, response|
        next unless inflection && @content_type_check.call(headers['Content-Type'])
        response.each do |body|
          begin
            new_response = MultiJson.load(body)
          rescue MultiJson::ParseError
            next
          end

          Transformations.transform(new_response, inflection_method(inflection))
          body.replace(MultiJson.dump(new_response))
        end
      end
    end

    private

    def inflection_method(inflection)
      if inflection == 'camel'
        camelize
      elsif inflection == 'dash'
        dasherize
      else
        # probably misconfigured, do nothing
        ->(string) { string }
      end
    end
  end
end
