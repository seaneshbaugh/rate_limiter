# frozen_string_literal: true

require 'singleton'

module RateLimiter
  class Config
    include Singleton

    attr_accessor :rate_limit_defaults

    def initialize
      @mutex = Mutex.new
      @enabled = true
      @timestamp_field = :created_at
      @rate_limit_defaults = {}
    end

    def enabled
      @mutex.synchronize { !!@enabled }
    end

    def enabled=(enable)
      @mutex.synchronize { @enabled = enable }
    end

    def timestamp_field
      @mutex.synchronize { @timestamp_field }
    end

    def timestamp_field=(field_name)
      @mutex.synchronize { @timestamp_field = field_name.to_sym }
    end
  end
end
