module RateLimiter
  module Controller
    def self.included(base)
      base.before_filter :set_rate_limiter_source
      base.before_filter :set_rate_limiter_controller_info
      base.before_filter :set_rate_limiter_enabled_for_controller
    end

    protected

    def user_for_rate_limiter
      current_user rescue nil
    end

    def info_for_rate_limiter
      {}
    end

    def rate_limiter_enabled_for_controller
      true
    end

    private

    def set_rate_limiter_source
      ::RateLimiter.source = user_for_rate_limiter
    end

    def set_rate_limiter_controller_info
      ::RateLimiter.controller_info = info_for_rate_limiter
    end

    def set_rate_limiter_enabled_for_controller
      ::RateLimiter.enabled_for_controller = rate_limiter_enabled_for_controller
    end
  end
end
