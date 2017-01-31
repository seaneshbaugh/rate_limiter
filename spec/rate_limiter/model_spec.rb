require 'spec_helper.rb'

describe RateLimiter::Model do
  it 'prevents a model from being saved too soon' do
    message1 = Message.new

    message1.ip_address = '127.0.0.1'

    message1.save

    message2 = Message.new

    message2.ip_address = '127.0.0.1'

    message2.save

    expect(message2.errors.count).to eq(1)
  end
end
