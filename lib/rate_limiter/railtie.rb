# frozen_string_literal: true

require 'rails/railtie'
require 'request_store/railtie'
require 'rate_limiter/frameworks/rails/controller'

module RateLimiter
  # Register model and controller extensions regardless of framework load order.
  class Railtie < ::Rails::Railtie
    # Register immediately so Active Record also works without a Rails application.
    ActiveSupport.on_load(:active_record) do
      include RateLimiter::Model unless include?(RateLimiter::Model)
    end

    initializer 'rate_limiter.controllers' do
      %i[action_controller_base action_controller_api].each do |hook|
        ActiveSupport.on_load(hook) do
          include RateLimiter::Rails::Controller unless include?(RateLimiter::Rails::Controller)
        end
      end
    end
  end
end
