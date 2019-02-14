# frozen_string_literal: true

require 'singleton'

module RateLimiter
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
