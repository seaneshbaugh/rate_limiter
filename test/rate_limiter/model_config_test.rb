# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class ModelConfigTest < ActiveSupport::TestCase
    describe 'rate_limit' do
      describe 'on:' do
        it 'allows field for the scope of rate limiting to be set' do
          dummy_model = Class.new do
            include ActiveModel::Model
            include ActiveModel::Validations
            include RateLimiter::Model

            attr_accessor :name

            rate_limit on: :name
          end

          _(dummy_model.rate_limiter_options[:on]).must_equal(:name)
        end
      end

      describe 'interval:' do
        it 'allows the time interval for rate limiting be set' do
          dummy_model = Class.new do
            include ActiveModel::Model
            include ActiveModel::Validations
            include RateLimiter::Model

            attr_accessor :ip_address

            rate_limit interval: 2.minutes
          end

          _(dummy_model.rate_limiter_options[:interval]).must_equal(120)
        end
      end

      describe 'if:' do
        it 'allows the if condition for rate limiting to be set' do
          dummy_model = Class.new do
            include ActiveModel::Model
            include ActiveModel::Validations
            include RateLimiter::Model

            attr_accessor :ip_address

            rate_limit if: -> (record) { true }
          end

          _(dummy_model.rate_limiter_options[:if]).wont_be_nil
        end
      end

      it 'allows the unless condition for rate limiting to be set' do
        dummy_model = Class.new do
          include ActiveModel::Model
          include ActiveModel::Validations
          include RateLimiter::Model

          attr_accessor :ip_address

          rate_limit unless: -> (record) { false }
        end

        _(dummy_model.rate_limiter_options[:unless]).wont_be_nil
      end
    end
  end
end
