# frozen_string_literal: true

require 'rails/generators/base'

module RateLimiter
  module Generators
    # Rails generator for installing the default RateLimiter initializer.
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('./templates', __dir__)

      desc 'Creates a RateLimiter initializer and copies a default locale file to your application.'

      def copy_initializer
        template('rate_limiter.rb', 'config/initializers/rate_limiter.rb')
      end

      def copy_locale
        copy_file('../../../../config/locales/en.yml', 'config/locales/rate_limiter.en.yml')
      end
    end
  end
end
