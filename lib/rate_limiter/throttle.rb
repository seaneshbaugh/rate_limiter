# frozen_string_literal: true

module RateLimiter
  # Limits the rate at which new records of an ActiveRecord model can be saved.
  # Checks to see if RateLimiter is enabled and, if all conditions are satisfied
  # and if any other records have been created within the time interval for rate
  # limiting.
  class Throttle
    DEFAULT_INTERVAL = 1.minute
    DEFAULT_ON_FIELD = :ip_address
    DEFAULT_TIMESTAMP_FIELD = :created_at

    def initialize(record, options = {})
      @record = record
      @options = options
    end

    # Has the rate limit been exceeded?
    def exceeded?
      enabled? && rate_limit? && others_for_rate_limiting.present?
    end

    private

    # Is RateLimiter enabled for this particular record?
    def enabled?
      RateLimiter.enabled? &&
        RateLimiter.request.enabled? &&
        RateLimiter.request.enabled_for_model?(@record.class)
    end

    # Proc that if present must return true for RateLimiter to be enabled for
    # this particular record.
    def if_condition
      @options[:if_condition]
    end

    # The time interval (in seconds)
    def interval
      @options[:interval] || DEFAULT_INTERVAL
    end

    # Arel query for finding records within the interval.
    def interval_query_params
      @record.class.arel_table[timestamp_field].gteq(Time.current - interval)
    end

    # An Array of model attribute names to match against.
    def on
      Array(@options[:on] || DEFAULT_ON_FIELD)
    end

    # Arel query for finding records that match the on attributes.
    def on_query_params
      on.map { |attr| @record.class.arel_table[attr].eq(@record.send(attr)) }.inject(&:or)
    end

    # Other records that fall within the time interval.
    def others_for_rate_limiting
      @record.class.where(on_query_params).where(interval_query_params)
    end

    # Are all of the conditions for rate limiting met for this record?
    def rate_limit?
      (if_condition.blank? || if_condition.call(@record)) && !unless_condition.try(:call, @record)
    end

    # Timestamp field to test the interval against.
    def timestamp_field
      @options[:timestamp_field] || DEFAULT_TIMESTAMP_FIELD
    end

    # Proc that if present must return false for RateLimiter to be enabled for
    # this particular record.
    def unless_condition
      @options[:unless_condition]
    end
  end
end
