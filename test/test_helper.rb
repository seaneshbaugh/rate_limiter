# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
end

require_relative 'dummy_app/config/environment'
require 'minitest/autorun'
require 'rails/test_help'
require 'minitest-spec-rails'

ActiveSupport.test_order = :random

module ActiveSupport
  class TestCase
    class << self
      alias context describe
    end
  end
end

require 'rails/generators/test_case'
require 'generators/rate_limiter/install_generator'
