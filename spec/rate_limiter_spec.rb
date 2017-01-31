require 'spec_helper.rb'

describe RateLimiter do
  describe 'Sanity Test' do
    it 'should be a Module' do
      expect(RateLimiter).to be_a(Module)
    end
  end
end
