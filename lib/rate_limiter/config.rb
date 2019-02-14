# frozen_string_literal: true

require 'singleton'

module RateLimiter
  # Global configuration that affects all threads. Thread-specific configuration
  # can be found in `/lib/rate_limiter.rb` and in
  # `/lib/rate_limite/frameworks/rails/controller.rb`.
  class Config
    include Singleton

    attr_accessor :rate_limit_defaults

    def initialize
      @mutex = Mutex.new
      @enabled = true
      @rate_limit_defaults = {}
    end

    def enabled
      @mutex.synchronize { !!@enabled }
    end

    def enabled=(enable)
      @mutex.synchronize { @enabled = enable }
    end
  end
end
