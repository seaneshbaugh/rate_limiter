# frozen_string_literal: true

module RateLimiter
  class Validator
    def initialize(record, options = {})
      @record = record
      @options = options
    end

    def validate
      return unless @record.rate_limit_exceeded?

      # TODO: I18nize this error message.
      @record.errors.add(:base, "You cannot create a new #{@record.class.name.downcase} yet.")

      false
    end
  end
end
