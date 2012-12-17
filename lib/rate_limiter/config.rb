require 'singleton'

module RateLimiter
  class Config
    include Singleton
    attr_accessor :enabled, :timestamp_field

    def initialize
      @enabled         = true
      @timestamp_field = :created_at
    end
  end
end
