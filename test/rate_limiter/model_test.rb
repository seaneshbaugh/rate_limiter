# frozen_string_literal: true

require 'test_helper'

class ModelTest < ActiveSupport::TestCase
  test 'prevents a model from being saved too soon' do
    user = User.new(email: 'test@test.com')

    message1 = Message.new({
      user: user,
      subject: 'test 1',
      body: 'test',
      ip_address: '127.0.0.1'
    })

    message1.save

    assert message1.persisted?

    message2 = Message.new({
      user: user,
      subject: 'test 2',
      body: 'test',
      ip_address: '127.0.0.1'
    })

    message2.save

    assert_equal(message2.errors.count, 1)

    assert_equal(message2.errors[:base], ['You cannot create a new message yet.'])

    refute message2.valid?

    refute message2.persisted?
  end
end
