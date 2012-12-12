require 'singleton'

require 'rate_limiter/config'
require 'rate_limiter/model'

module RateLimiter
  def self.timestamp_field= field_name
    RateLimiter.config.timestamp_field = field_name
  end

  def self.timestamp_field
    RateLimiter.config.timestamp_field
  end

  private

  def self.config
    @@config ||= RateLimiter::Config.instance
  end
end

ActiveSupport.on_load(:active_record) do
  include RateLimiter::Model
end
