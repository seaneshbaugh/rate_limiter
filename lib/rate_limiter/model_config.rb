# frozen_string_literal: true

require 'rate_limiter/validator'

module RateLimiter
  # Sets up RateLimiter configuration for an ActiveRecord model.
  class ModelConfig
    def initialize(model_class)
      @model_class = model_class
    end

    # Set up `@model_class` for RateLimiter. Includes callbacks, class
    # attributes, instance methods, etc.
    def setup(options = {})
      @model_class.send(:include, Model::InstanceMethods)
      setup_options(options)
      setup_validations
    end

    private

    def setup_options(options)
      @model_class.class_attribute :rate_limiter_options
      @model_class.rate_limiter_options = options.dup
    end

    def setup_validations
      # TODO: Maybe make it so the context can be configured.
      @model_class.validate(on: :create) do |record|
        Validator.new(record).validate
      end
    end
  end
end
