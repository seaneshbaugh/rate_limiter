module RateLimiter
  class Config
    include Singleton
    attr_accessor :timestamp_field

    def initialize
      @timestamp_field = :created_at
    end
  end
end
