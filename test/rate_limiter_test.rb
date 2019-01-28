# frozen_string_literal: true

require 'test_helper'

class RateLimiterTest < ActiveSupport::TestCase
  test 'RateLimiter is a Module' do
    assert_kind_of(Module, RateLimiter)
  end
end
