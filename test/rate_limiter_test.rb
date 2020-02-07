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
      _(RateLimiter.config.enabled).must_equal(true)
      RateLimiter.config.enabled = false
      _(RateLimiter.config.enabled).must_equal(false)
    end

    it 'accepts a block and yields the config instance' do
      _(RateLimiter.config.enabled).must_equal(true)
      RateLimiter.config { |c| c.enabled = false }
      _(RateLimiter.config.enabled).must_equal(false)
    end
  end

  describe '.configure' do
    it 'is an alias for the `config` method' do
      _(RateLimiter.method(:configure)).must_equal(RateLimiter.method(:config))
    end
  end

  context 'when enabled' do
    after do
      RateLimiter.enabled = true
    end

    it 'affects all threads' do
      _(RateLimiter.enabled?).must_equal(true)
      Thread.new { RateLimiter.enabled = false }.join
      _(RateLimiter.enabled?).must_equal(false)
    end
  end
end
