module RateLimiter
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def rate_limit options = {}
        send :include, InstanceMethods

        class_attribute :rate_limit_on
        self.rate_limit_on = options[:on] || :ip_address

        class_attribute :rate_limit_interval
        self.rate_limit_interval = options[:interval] || 1.minute

        class_attribute :rate_limit_if_condition
        self.if_condition = options[:if]

        class_attribute :rate_limit_unless_condition
        self.unless_condition = options[:unless]

        self.before_create :check_rate_limit
      end
    end

    module InstanceMethods
      def check_rate_limit
        klass = self.class

        others = klass.where("#{klass.rate_limit_on} =? AND created_at >= ?", self.send(klass.rate_limit_on), Time.now - klass.rate_limit_interval)

        if others.present?
          # TODO: Come up with a better error message.
          self.errors.add(:base, "You cannot create a new #{klass.name.downcase} yet.")

          false
        end
      end

      def rate_limit?
        (rate_limit_if_condition.blank? || rate_limit_if_condition.call(self)) && !rate_limit_unless_condition.try(:call, self)
      end
    end
  end
end
