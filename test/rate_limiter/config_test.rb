# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ConfigTest < ActiveSupport::TestCase
    test '.instance returns the singleton instance' do
      assert ::RateLimiter::Config.instance
    end

    test '.new raises NoMethodError' do
      assert_raises(NoMethodError) do
        ::RateLimiter::Config.new
      end
    end
  end
end
