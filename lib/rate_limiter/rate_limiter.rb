# frozen_string_literal: true

module RateLimiter
  # TODO: Reconsider name for this class. It makes using :: before the
  # `RateLimiter` module necessary almost everywhere it's used. It's kind of
  # annoying and seems generally ugly. Maybe something like `Throttle`?
  class RateLimiter
    DEFAULT_INTERVAL = 1.minute
    DEFAULT_ON_FIELD = :ip_address
    DEFAULT_TIMESTAMP_FIELD = :created_at

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

    def interval
      @options[:interval] || DEFAULT_INTERVAL
    end

    def interval_query_params
      @record.class.arel_table[timestamp_field].gteq(Time.current - interval)
    end

    def on
      Array(@options[:on] || DEFAULT_ON_FIELD)
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
      @options[:timestamp_field] || DEFAULT_TIMESTAMP_FIELD
    end

    def unless_condition
      @options[:unless_condition]
    end
  end
end
