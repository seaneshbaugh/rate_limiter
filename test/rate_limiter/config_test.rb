# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ConfigTest < ActiveSupport::TestCase
    describe '.instance' do
      it 'returns the singleton instance' do
        assert ::RateLimiter::Config.instance
      end
    end

    describe '.new' do
      it 'raises NoMethodError' do
        assert_raises(NoMethodError) do
          ::RateLimiter::Config.new
        end
      end
    end
  end
end
