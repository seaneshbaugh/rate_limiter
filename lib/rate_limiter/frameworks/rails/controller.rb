# frozen_string_literal: true

module RateLimiter
  module Rails
    # Extensions for Rails controllers. Allows for rate limiting to be turned on
    # or off without disabling it on the model.
    module Controller
      def self.included(base)
        base.before_action(
          :set_rate_limiter_enabled_for_controller,
          :set_rate_limiter_source
        )
      end

      protected

      # TODO: Reconsider whether or not this is even needed.
      def user_for_rate_limiter
        current_user
      rescue NoMethodError
        nil
      end

      # Returns `true` or `false` depending on whether rate imiting should be
      # active for the current request for all models.
      #
      # Override this method in your controller to turn rate limiting on or off.
      #
      # ```
      # def rate_limiter_enabled_for_controller
      #   # It is recommended that you always call `super` here unless simply
      #   # returning `false`.
      #   super && !user_for_rate_limiter.has_role?(:admin)
      # end
      # ```
      def rate_limiter_enabled_for_controller
        ::RateLimiter.enabled?
      end

      private

      # Tells RateLimiter whether rate limiting should be enabled for the
      # current request.
      def set_rate_limiter_enabled_for_controller
        ::RateLimiter.request.enabled = rate_limiter_enabled_for_controller
      end

      # TODO: Reconsider whether or not this is even needed.
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
