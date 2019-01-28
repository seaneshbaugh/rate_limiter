# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require_relative 'dummy_app/config/environment'
require 'minitest/autorun'
require 'rails/test_help'

ActiveSupport.test_order = :random if ActiveSupport.respond_to?(:test_order)
