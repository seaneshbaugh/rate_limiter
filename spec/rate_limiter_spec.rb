# encoding: utf-8
require 'spec_helper.rb'

describe RateLimiter do
  describe 'Sanity Test' do
    it 'should be a Module' do
      RateLimiter.should be_a(Module)
    end
  end
end
