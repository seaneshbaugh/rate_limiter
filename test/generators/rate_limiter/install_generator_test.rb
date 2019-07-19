# frozen_string_literal: true

require 'test_helper'
require 'pry'
module RateLimiter
  module Generators
    class InstallGeneratorTest < ::Rails::Generators::TestCase
      tests ::RateLimiter::Generators::InstallGenerator
      destination File.expand_path('../../../tmp', __dir__)
      setup :prepare_destination

      test 'all files are properly created' do
        run_generator

        assert_file 'config/initializers/rate_limiter.rb'
        assert_file 'config/locales/rate_limiter.en.yml'
      end
    end
  end
end
