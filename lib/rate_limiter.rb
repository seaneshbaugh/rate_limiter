require 'singleton'

require 'rate_limiter/config'
require 'rate_limiter/controller'
require 'rate_limiter/model'

module RateLimiter
  def self.enabled=(value)
    RateLimiter.config.enabled = value
  end

  def self.enabled?
    !!RateLimiter.config.enabled
  end

  def self.enabled_for_controller=(value)
    RateLimiter.store[:request_enabled_for_controller] = value
  end

  def self.enabled_for_controller?
    !!RateLimiter.store[:request_enabled_for_controller]
  end

  def self.timestamp_field=(field_name)
    RateLimiter.config.timestamp_field = field_name
  end

  def self.timestamp_field
    RateLimiter.config.timestamp_field
  end

  def self.source=(value)
    RateLimiter.store[:source] = value
  end

  def self.source
    RateLimiter.store[:source]
  end

  def self.controller_info=(value)
    RateLimiter.store[:controller_info] = value
  end

  def self.controller_info
    RateLimiter.store[:controller_info]
  end

  private

  def self.store
    Thread.current[:rate_limiter] || { :request_enabled_for_controller => true }
  end

  def self.config
    @@config ||= RateLimiter::Config.instance
  end
end

ActiveSupport.on_load(:active_record) do
  include RateLimiter::Model
end

ActiveSupport.on_load(:action_controller) do
  include RateLimiter::Controller
end
