module RateLimiter
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def rate_limit(options = {})
        send :include, InstanceMethods

        class_attribute :rate_limit_on
        self.rate_limit_on = options[:on] || :ip_address

        class_attribute :rate_limit_interval
        self.rate_limit_interval = options[:interval] || 1.minute

        class_attribute :rate_limit_if_condition
        self.rate_limit_if_condition = options[:if]

        class_attribute :rate_limit_unless_condition
        self.rate_limit_unless_condition = options[:unless]

        class_attribute :rate_limit_enabled_for_model
        self.rate_limit_enabled_for_model = true

        before_create :check_rate_limit
      end

      def rate_limit_off
        self.rate_limit_enabled_for_model = false
      end

      def rate_limit_on
        self.rate_limit_enabled_for_model = true
      end
    end

    module InstanceMethods
      def check_rate_limit
        return true unless switched_on? && rate_limit? && others_for_rate_limiting.present?

        # TODO: i18nize this error message.
        errors.add(:base, "You cannot create a new #{self.class.name.downcase} yet.")

        false
      end

      def switched_on?
        RateLimiter.enabled? && RateLimiter.enabled_for_controller? && self.class.rate_limit_enabled_for_model
      end

      def rate_limit?
        (rate_limit_if_condition.blank? || rate_limit_if_condition.call(self)) && !rate_limit_unless_condition.try(:call, self)
      end

      private

      def others_for_rate_limiting
        self.class.where(rate_limit_on_query_params).where(rate_limit_interval_query_params)
      end

      def rate_limit_on_query_params
        { self.class.rate_limit_on => send(self.class.rate_limit_on) }
      end

      def rate_limit_interval_query_params
        self.class.arel_table[RateLimiter.config.timestamp_field].gteq(Time.now - self.class.rate_limit_interval)
      end
    end
  end
end
