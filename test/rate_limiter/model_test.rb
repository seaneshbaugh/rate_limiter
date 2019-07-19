# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ModelTest < ActiveSupport::TestCase
    describe 'saving a record' do
      let(:user) { User.new(email: 'test@test.com') }
      let(:message1) { Message.new(user: user, subject: 'test 1', body: 'test', ip_address: '127.0.0.1') }
      let(:message2) { Message.new(user: user, subject: 'test 2', body: 'test', ip_address: '127.0.0.1') }

      context 'when less than the rate limiter interval amount of time has passed' do
        it 'prevents the record from being saved' do
          time1 = Time.local(2019, 7, 19, 12, 0, 0)

          Timecop.freeze(time1) do
            message1.save

            assert message1.persisted?

            assert message1.valid?
          end

          time2 = Time.local(2019, 7, 19, 12, 0, 15)

          Timecop.freeze(time2) do
            message2.save

            refute message2.persisted?

            refute message2.valid?

            assert_equal(1, message2.errors.count)

            assert_equal(['You cannot create a new Message yet.'], message2.errors[:base])
          end
        end
      end

      context 'when more than the rate limiter interval amount of time has passed' do
        it 'does not prevent the record from being saved' do
          time1 = Time.local(2019, 7, 19, 12, 0, 0)

          Timecop.freeze(time1) do
            message1.save

            assert message1.persisted?

            assert message1.valid?
          end


          time2 = Time.local(2019, 7, 19, 12, 15, 0)

          Timecop.freeze(time2) do
            message2.save

            assert message2.persisted?

            assert message2.valid?

            assert_equal(0, message2.errors.count)

            assert_equal([], message2.errors[:base])
          end
        end
      end
    end
  end
end
