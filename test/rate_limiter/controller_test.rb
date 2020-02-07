# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ControllerTest < ActionDispatch::IntegrationTest
    describe '#rate_limiter_enabled_for_controller' do
      before do
        user = User.create(email: 'test@test.com')

        post create_session_url, params: { email: user.email }
      end

      context 'returns false' do
        it 'disables rate limiting for the controller' do
          MessagesController.define_method(:rate_limiter_enabled_for_controller) do
            false
          end

          count = Message.count

          post messages_url, params: { message: { subject: 'test 1', body: 'test' } }

          assert_response :see_other

          post messages_url, params: { message: { subject: 'test 2', body: 'test' } }

          assert_response :see_other

          _(Message.count).must_equal(count + 2)

          MessagesController.define_method(:rate_limiter_enabled_for_controller) do
            true
          end
        end
      end
    end
  end
end
