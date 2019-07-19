# frozen_string_literal: true

module RateLimiter
  class Validator
    def initialize(record, options = {})
      @record = record
      @options = options
    end

    def validate
      return unless @record.rate_limit_exceeded?

      @record.errors.add(:base, I18n.t('rate_limiter.errors.rate_limit_exceeded', object_type: object_type, default: default_error_message))

      false
    end

    private

    def default_error_message
      "You cannot create a new #{object_type} yet."
    end

    def object_type
      @record.class.name
    end
  end
end
