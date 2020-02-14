# frozen_string_literal: true

require 'rate_limiter/model_config'
require 'rate_limiter/throttle'

module RateLimiter
  module Model
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      # Tell the model to limit creation of records based on an attribute for a
      # given interval of time.
      #
      # Options:
      #
      # - :on - The attribute to limit on. Defaults to `:ip_address`. Set to an
      # array to limit on multiple attributes (e.g. `:ip_address` or `:user_id`.
      # - :interval - The amount of time that must have elapses since the last
      # record that has the same value as the attribute indicated by the  `:on`
      # option in seconds. Defaults to 1 minute.
      # - :if, :unless - Procs that specify the conditions for when record
      # creation rate limiting should occur.
      def rate_limit(options = {})
        defaults = RateLimiter.config.rate_limit_defaults
        rate_limiter.setup(defaults.merge(options))
      end

      def rate_limiter
        ModelConfig.new(self)
      end
    end

    module InstanceMethods
      def rate_limit_exceeded?
        throttle.exceeded?
      end

      def throttle
        Throttle.new(self, self.class.rate_limiter_options)
      end
    end
  end
end
