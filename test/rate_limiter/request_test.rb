# frozen_string_literal: true

require 'test_helper'

module RateLimiter
  class RequestTest < ActiveSupport::TestCase
    describe '.disable_model' do
      after do
        ::RateLimiter.request.enable_model(Message)
      end

      it 'sets enabled_for_model? to false' do
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true)
        ::RateLimiter.request.disable_model(Message)
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(false)
      end
    end

    describe '.enable_model' do
      after do
        ::RateLimiter.request.enable_model(Message)
      end

      it 'sets enabled_for_model? to true' do
        ::RateLimiter.request.disable_model(Message)
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(false)
        ::RateLimiter.request.enable_model(Message)
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true)
      end
    end

    describe '.enabled?' do
      after do
        ::RateLimiter.request.enabled = true
      end

      it 'returns true if enabled' do
        ::RateLimiter.request.enabled = true
        _(::RateLimiter.request.enabled?).must_equal(true)
      end

      it 'returns false if disabled' do
        ::RateLimiter.request.enabled = false
        _(::RateLimiter.request.enabled?).must_equal(false)
      end
    end

    describe '.enabled=' do
      after do
        ::RateLimiter.request.enabled = true
      end

      it 'sets enabled? to true' do
        ::RateLimiter.request.enabled = true
        _(::RateLimiter.request.enabled?).must_equal(true)
      end

      it 'sets enabled? to false' do
        ::RateLimiter.request.enabled = false
        _(::RateLimiter.request.enabled?).must_equal(false)
      end
    end

    describe '.enable_for_model' do
      after do
        ::RateLimiter.request.enable_model(Message)
      end

      it 'sets enabled_for_model? to true' do
        ::RateLimiter.request.enabled_for_model(Message, false)
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(false)
        ::RateLimiter.request.enabled_for_model(Message, true)
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true)
      end

      it 'sets enabled_for_model? to false' do
        ::RateLimiter.request.enabled_for_model(Message, true)
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true)
        ::RateLimiter.request.enabled_for_model(Message, false)
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(false)
      end
    end

    describe '.enabled_for_model?' do
      it 'returns true for models that are rate limited' do
        _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true)
      end

      it 'returns false for models that are not rate limited' do
        _(::RateLimiter.request.enabled_for_model?(User)).must_equal(false)
      end
    end

    describe '.source' do
      after do
        ::RateLimiter.request.source = nil
      end

      context 'when set to a proc' do
        it 'evaluates the proc each time a record is created' do
          call_count = 0
          ::RateLimiter.request.source = -> { call_count += 1 }
          _(::RateLimiter.request.source).must_equal(1)
          _(::RateLimiter.request.source).must_equal(2)
        end
      end

      context 'when set to a primitive value' do
        it 'returns the primitive value' do
          ::RateLimiter.request.source = :some_source
          _(::RateLimiter.request.source).must_equal(:some_source)
        end
      end
    end

    describe '.with' do
      context 'when a block is given' do
        context 'with all allowed options' do
          after do
            ::RateLimiter.request.source = nil
          end

          it 'sets options only for the block passed' do
            ::RateLimiter.request.source = :some_source

            ::RateLimiter.request.with(source: :some_other_source, enabled_for_Message: false) do
              _(::RateLimiter.request.source).must_equal(:some_other_source)
              _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(false)
            end

            _(::RateLimiter.request.source).must_equal(:some_source)
            _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true)
          end

          it 'sets options only for the current thread' do
            ::RateLimiter.request.source = :some_source

            ::RateLimiter.request.with(source: :some_other_source, enabled_for_Message: false) do
              _(::RateLimiter.request.source).must_equal(:some_other_source)
              _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(false)
              Thread.new { _(::RateLimiter.request.source).must_be_nil }.join
              Thread.new { _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true) }.join
            end

            _(::RateLimiter.request.source).must_equal(:some_source)
            _(::RateLimiter.request.enabled_for_model?(Message)).must_equal(true)
          end
        end

        context 'with some invalid options' do
          it 'raises an `InvalidOption` error' do
            exception = _(proc do
                ::RateLimiter.request.with(source: :some_source, invalid_option: 'Oops!') do
                  raise 'This block should not be reached.'
                end
              end).must_raise(::RateLimiter::Request::InvalidOption)

            _(exception.message).must_equal('Invalid option: invalid_option')
          end
        end

        context 'with all invalid options' do
          it 'raises an `InvalidOption` error' do
            exception = _(proc do
                ::RateLimiter.request.with(invalid_option: 'Oops!', other_invalid_option: 'Oh no!') do
                  raise 'This block should not be reached.'
                end
              end).must_raise(::RateLimiter::Request::InvalidOption)

            _(exception.message).must_equal('Invalid option: invalid_option')
          end
        end
      end
    end
  end
end
