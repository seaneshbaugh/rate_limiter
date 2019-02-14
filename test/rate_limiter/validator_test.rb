# frozen_string_literal: true

module RateLimiter
  class ValidatorTest < ActiveSupport::TestCase
    class DummyModel
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :name

      def rate_limit_exceeded?
        true
      end
    end

    describe '.validate' do
      it 'adds an error to a model if the rate limit is exceeded' do
        dummy = DummyModel.new(name: 'Test')

        validator = Validator.new(dummy)

        validator.validate

        dummy.errors[:base].must_equal(['You cannot create a new RateLimiter::ValidatorTest::DummyModel yet.'])
      end
    end
  end
end
