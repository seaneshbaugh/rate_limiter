# frozen_string_literal: true

require 'test_helper'

class RateLimiterTest < ActiveSupport::TestCase
  describe '.config' do
    before do
      ::RateLimiter.config.enabled = true
    end

    after do
      ::RateLimiter.config.enabled = true
    end

    it 'allows for config values to be set' do
      ::RateLimiter.config.enabled.must_equal(true)

      ::RateLimiter.config.enabled = false

      ::RateLimiter.config.enabled.must_equal(false)
    end

    it 'accepts a block and yields the config instance' do
      assert_equal(::RateLimiter.config.enabled, true)

      ::RateLimiter.config { |c| c.enabled = false }

      assert_equal(::RateLimiter.config.enabled, false)
    end
  end
end
