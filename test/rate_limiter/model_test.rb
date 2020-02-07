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

            _(message1.persisted?).must_equal(true)

            _(message1.valid?).must_equal(true)
          end

          time2 = Time.local(2019, 7, 19, 12, 0, 15)

          Timecop.freeze(time2) do
            message2.save

            _(message2.persisted?).must_equal(false)

            _(message2.valid?).must_equal(false)

            _(message2.errors.count).must_equal(1)

            _(message2.errors[:base]).must_equal(['You cannot create a new Message yet.'])
          end
        end
      end

      context 'when more than the rate limiter interval amount of time has passed' do
        it 'does not prevent the record from being saved' do
          time1 = Time.local(2019, 7, 19, 12, 0, 0)

          Timecop.freeze(time1) do
            message1.save

            _(message1.persisted?).must_equal(true)

            _(message1.valid?).must_equal(true)
          end


          time2 = Time.local(2019, 7, 19, 12, 15, 0)

          Timecop.freeze(time2) do
            message2.save

            _(message2.persisted?).must_equal(true)

            _(message2.valid?).must_equal(true)

            _(message2.errors.count).must_equal(0)

            _(message2.errors[:base]).must_equal([])
          end
        end
      end
    end
  end
end
