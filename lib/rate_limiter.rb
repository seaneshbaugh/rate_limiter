# frozen_string_literal: true

require 'active_support/all'
require 'active_record'

require 'rate_limiter/config'
require 'rate_limiter/model'
require 'rate_limiter/request'

module RateLimiter
  class << self
    def config
      @config ||= ::RateLimiter::Config.instance
      yield @config if block_given?
      @config
    end
    alias_method :configure, :config

    def enabled=(value)
      ::RateLimiter.config.enabled = value
    end

    def enabled?
      ::RateLimiter.config.enabled
    end

    def request(options = nil, &block)
      if options.nil? && !block_given?
        Request
      else
        Request.with(options, &block)
      end
    end

    def timestamp_field=(field_name)
      ::RateLimiter.config.timestamp_field = field_name
    end

    def timestamp_field
      ::RateLimiter.config.timestamp_field
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include RateLimiter::Model
end

if defined?(::Rails)
  if defined?(::Rails.application)
    require 'rate_limiter/frameworks/rails'
  else
    Kernel.warn('RateLimiter has been loaded before Rails.')
  end
end
