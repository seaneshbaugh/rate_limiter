# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ControllerTest < ActionDispatch::IntegrationTest
    setup do
      user = User.create(email: 'test@test.com')

      post create_session_url, params: { email: user.email }
    end

    test 'rate limit can be disabled for a controller' do
      MessagesController.define_method(:rate_limiter_enabled_for_controller) do
        false
      end

      count = Message.count

      post messages_url, params: { message: { subject: 'test 1', body: 'test' } }

      assert_response :see_other

      post messages_url, params: { message: { subject: 'test 2', body: 'test' } }

      assert_response :see_other

      assert_equal(count + 2, Message.count)

      MessagesController.define_method(:rate_limiter_enabled_for_controller) do
        true
      end
    end
  end
end
