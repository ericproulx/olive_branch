# frozen_string_literal: true
class Transformations
  class << self
    def transform(value, transform_method)
      case value
      when Array then value.map { |item| transform(item, transform_method) }
      when Hash then value.deep_transform_keys! { |key| transform(key, transform_method) }
      when String then transform_method.call(value)
      else value
      end
    end

    def camelize(string)
      string.underscore.camelize(:lower)
    end

    def dasherize(string)
      string.dasherize
    end

    def underscore_params(env)
      req = ActionDispatch::Request.new(env)
      req.request_parameters
      req.query_parameters

      env['action_dispatch.request.request_parameters'.freeze].deep_transform_keys!(&:underscore)
      env['action_dispatch.request.query_parameters'.freeze].deep_transform_keys!(&:underscore)
    end
  end
end
