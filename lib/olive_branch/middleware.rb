# frozen_string_literal: true

require 'olive_branch/transformations'
require 'olive_branch/configuration'
require 'json'

module OliveBranch
  class Middleware
    def initialize(app)
      @app = app
    end

    # thread_safe
    def call(env)
      dup._call env
    end

    def _call(env)
      inflection = env.fetch(OliveBranch.configuration.header_key, OliveBranch.configuration.default_inflection)
      Transformations.underscore_params(env) if transform_request_params?(inflection, env['CONTENT_TYPE'])
      status, headers, body = @app.call(env)
      return [status, headers, body] unless transform_body?(inflection, headers)
      new_body = transform_body(body, inflection)
      headers['Content-Length'] = new_body.length.to_s
      [status, headers, new_body]
    end

    private

    def transform_request_params?(inflection, content_type)
      inflection && OliveBranch.configuration.content_type_check.call(content_type)
    end

    def transform_body?(inflection, headers)
      inflection && OliveBranch.configuration.content_type_check.call(headers['Content-Type'])
    end

    def transform_body(body, inflection)
      [].tap do |new_body|
        body.each do |str|
          begin
            parsed_body = JSON.parse str
          rescue JSON::ParserError
            new_body << str
            next
          end
          Transformations.transform(parsed_body, inflection_method(inflection))
          new_body << JSON.dump(parsed_body)
        end
      end
    end

    def inflection_method(inflection)
      if inflection == 'camel'
        OliveBranch.configuration.camelize
      elsif inflection == 'dash'
        OliveBranch.configuration.dasherize
      else
        # probably misconfigured, do nothing
        ->(string) { string }
      end
    end
  end
end
