# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ConfigTest < ActiveSupport::TestCase
    describe '.instance' do
      it 'returns the singleton instance' do
        _(RateLimiter::Config.instance).must_be_instance_of(RateLimiter::Config)
      end
    end

    describe '.new' do
      it 'raises NoMethodError' do
        _(proc do
            RateLimiter::Config.new
          end).must_raise(NoMethodError)
      end
    end
  end
end
