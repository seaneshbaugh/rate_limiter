# frozen_string_literal: true

require 'active_support/all'
require 'active_record'
require 'rails/railtie'

require 'rate_limiter/config'
require 'rate_limiter/model'
require 'rate_limiter/request'

# Extend your ActiveRecord models with the ability to limit the rate at which
# they are saved.
module RateLimiter
  class << self
    # Return the RateLimiter singleton configuration object. This is for all
    # threads.
    def config
      @config ||= Config.instance
      yield @config if block_given?
      @config
    end
    alias configure config

    # Switches RateLimiter on or off, for all threads.
    def enabled=(value)
      config.enabled = value
    end

    # Returns `true` if RateLimiter is on, `false if it is off. This is for all
    # threads.
    def enabled?
      config.enabled
    end

    # Gets the options local to the current request.
    #
    # If given a block the options passed in are set, the block is executed,
    # previous options are restored, and the return value of the block is
    # returned.
    def request(options = nil, &block)
      if options.nil? && !block_given?
        Request
      else
        Request.with(options, &block)
      end
    end
  end
end

require 'rate_limiter/railtie'
