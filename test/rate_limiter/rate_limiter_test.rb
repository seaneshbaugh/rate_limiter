# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class RateLimiterTest < ActiveSupport::TestCase
    describe '#exceeded?' do
      let(:user) { User.new(email: 'test@test.com') }
      let(:message1) { Message.new(user: user, subject: 'test 1', body: 'test', ip_address: '127.0.0.1') }
      let(:message2) { Message.new(user: user, subject: 'test 2', body: 'test', ip_address: '127.0.0.1') }

      context 'when enabled? and rate_limit? and others_for_rate_limiting.present?' do
        it 'returns true' do
          message1.save

          assert message1.persisted?

          rate_limiter = ::RateLimiter::RateLimiter.new(message2)

          assert rate_limiter.exceeded?
        end
      end

      context 'when enabled? is false' do
        after do
          ::RateLimiter.config.enabled = true
        end

        it 'returns false' do
          ::RateLimiter.config.enabled = false

          message1.save

          assert message1.persisted?

          rate_limiter = ::RateLimiter::RateLimiter.new(message2)

          refute rate_limiter.exceeded?
        end
      end

      context 'when rate_limit? is false' do
        it 'returns false' do
          if_condition = -> (_record) { false }

          message1.save

          assert message1.persisted?

          rate_limiter = ::RateLimiter::RateLimiter.new(message2, if_condition: if_condition)

          refute rate_limiter.exceeded?
        end
      end

      context 'when others_for_rate_limiting? is empty' do
        it 'returns false' do
          rate_limiter = ::RateLimiter::RateLimiter.new(message1)

          refute rate_limiter.exceeded?
        end
      end
    end
  end
end
