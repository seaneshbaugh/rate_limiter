# frozen_string_literal: true

require 'test_helper'

class RateLimiterTest < ActiveSupport::TestCase
  describe '.config' do
    before do
      RateLimiter.config.enabled = true
    end

    after do
      RateLimiter.config.enabled = true
    end

    it 'allows for config values to be set' do
      RateLimiter.config.enabled.must_equal(true)
      RateLimiter.config.enabled = false
      RateLimiter.config.enabled.must_equal(false)
    end

    it 'accepts a block and yields the config instance' do
      RateLimiter.config.enabled.must_equal(true)
      RateLimiter.config { |c| c.enabled = false }
      RateLimiter.config.enabled.must_equal(false)
    end
  end

  describe '.configure' do
    it 'is an alias for the `config` method' do
      RateLimiter.method(:configure).must_equal(RateLimiter.method(:config))
    end
  end
end
