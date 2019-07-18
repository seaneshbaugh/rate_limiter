# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ModelTest < ActiveSupport::TestCase
    test 'prevents a model from being saved too soon' do
      user = User.new(email: 'test@test.com')

      message1 = Message.new(
        user: user,
        subject: 'test 1',
        body: 'test',
        ip_address: '127.0.0.1'
      )

      message1.save

      assert message1.persisted?

      message2 = Message.new(
        user: user,
        subject: 'test 2',
        body: 'test',
        ip_address: '127.0.0.1'
      )

      message2.save

      refute message2.persisted?

      refute message2.valid?

      assert_equal(1, message2.errors.count)

      assert_equal(['You cannot create a new Message yet.'], message2.errors[:base])
    end
  end
end
