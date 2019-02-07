# frozen_string_literal: true

module RateLimiter
  class RateLimiter
    def initialize(record, options = {})
      @record = record
      @options = options
    end

    def exceeded?
      enabled? && rate_limit? && others_for_rate_limiting.present?
    end

    private

    def enabled?
      ::RateLimiter.enabled? &&
        ::RateLimiter.request.enabled? &&
        ::RateLimiter.request.enabled_for_model?(@record.class)
    end

    def if_condition
      @options[:if_condition]
    end

    # TODO: Use config for default.
    def interval
      @options[:interval] || 1.minute
    end

    def interval_query_params
      @record.class.arel_table[timestamp_field].gteq(Time.current - interval)
    end

    # TODO: Use config for default.
    def on
      @options[:on] || [:ip_address]
    end

    def on_query_params
      on.map { |attr| @record.class.arel_table[attr].eq(@record.send(attr)) }.inject(&:or)
    end

    def others_for_rate_limiting
      @record.class.where(on_query_params).where(interval_query_params)
    end

    def rate_limit?
      (if_condition.blank? || if_condition.call(@record)) && !unless_condition.try(:call, @record)
    end

    def timestamp_field
      @options[:timestamp_field] || ::RateLimiter.config.timestamp_field
    end

    def unless_condition
      @options[:unless_condition]
    end
  end
end
