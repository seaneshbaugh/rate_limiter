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
            include ::RateLimiter::Model

            attr_accessor :name

            rate_limit on: :name
          end

          assert_equal :name, dummy_model.rate_limiter_options[:on]
        end
      end

      describe 'interval:' do
        it 'allows the time interval for rate limiting be set' do
          dummy_model = Class.new do
            include ActiveModel::Model
            include ActiveModel::Validations
            include ::RateLimiter::Model

            attr_accessor :ip_address

            rate_limit interval: 2.minutes
          end

          assert_equal 120, dummy_model.rate_limiter_options[:interval]
        end
      end

      describe 'if:' do
        it 'allows the if condition for rate limiting to be set' do
          dummy_model = Class.new do
            include ActiveModel::Model
            include ActiveModel::Validations
            include ::RateLimiter::Model

            attr_accessor :ip_address

            rate_limit if: -> (record) { true }
          end

          assert dummy_model.rate_limiter_options[:if]
        end
      end

      it 'allows the unless condition for rate limiting to be set' do
        dummy_model = Class.new do
          include ActiveModel::Model
          include ActiveModel::Validations
          include ::RateLimiter::Model

          attr_accessor :ip_address

          rate_limit unless: -> (record) { false }
        end

        assert dummy_model.rate_limiter_options[:unless]
      end
    end
  end
end
