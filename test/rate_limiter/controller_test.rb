# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ControllerTest < ActionDispatch::IntegrationTest
    describe '#rate_limiter_enabled_for_controller' do
      before do
        user = User.create(email: 'test@test.com')

        post create_session_url, params: { email: user.email }
      end

      context 'with default enablement' do
        it 'creates a message, renders it, and rejects another within the interval' do
          Timecop.freeze do
            assert_difference('Message.count', 1) do
              post messages_url, params: { message: { subject: 'First message', body: 'Hello' } }
            end
            assert_response :see_other

            follow_redirect!
            assert_response :success
            assert_select '.message-subject', text: /First message/

            get messages_url
            assert_response :success
            assert_select '.messages a', text: 'First message'

            assert_no_difference('Message.count') do
              post messages_url, params: { message: { subject: 'Second message', body: 'Hello again' } }
            end
            assert_response :unprocessable_content
            assert_select '.flash-error', text: /You cannot create a new Message yet/
          end
        end
      end

      context 'returns false' do
        before do
          MessagesController.define_method(:rate_limiter_enabled_for_controller) { false }
        end

        after do
          MessagesController.remove_method(:rate_limiter_enabled_for_controller)
        end

        it 'disables rate limiting for the controller' do
          count = Message.count

          post messages_url, params: { message: { subject: 'test 1', body: 'test' } }

          assert_response :see_other

          post messages_url, params: { message: { subject: 'test 2', body: 'test' } }

          assert_response :see_other

          _(Message.count).must_equal(count + 2)
        end
      end
    end
  end
end
