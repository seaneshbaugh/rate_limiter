# frozen_string_literal: true

module RateLimiter
  module Rails
    module Controller
      def self.included(base)
        base.before_action(
          :set_rate_limiter_enabled_for_controller,
          :set_rate_limiter_source
        )
      end

      protected

      def user_for_rate_limiter
        current_user
      rescue NoMethodError
        nil
      end

      def rate_limiter_enabled_for_controller
        ::RateLimiter.enabled?
      end

      private

      def set_rate_limiter_enabled_for_controller
        ::RateLimiter.request.enabled = rate_limiter_enabled_for_controller
      end

      def set_rate_limiter_source
        ::RateLimiter.request.source = user_for_rate_limiter if rate_limiter_enabled_for_controller
      end
    end
  end
end

if defined?(::ActionController)
  ::ActiveSupport.on_load(:action_controller) do
    include ::RateLimiter::Rails::Controller
  end
end
