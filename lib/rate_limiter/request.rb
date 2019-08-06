# frozen_string_literal: true

require 'request_store'

module RateLimiter
  # Manages configuration and state for the current HTTP request such as
  # `source`.
  #
  # It is recommended you don't use `RateLimiter::Request` directly. Instead
  # use `RateLimiter.request.
  module Request
    class InvalidOption < RuntimeError
    end

    class << self
      # Turn off RateLimiter for the given model for this request.
      def disable_model(model_class)
        enabled_for_model(model_class, false)
      end

      # Turn on RateLimiter for the given model for this request.
      def enable_model(model_class)
        enabled_for_model(model_class, true)
      end

      # Returns `true` if RateLimiter is enabled for the current request,
      # `false` otherwise.
      def enabled?
        !!store[:enabled]
      end

      # Sets whether RateLimiter is enabled or disabled for the current request.
      def enabled=(value)
        store[:enabled] = value
      end

      # Sets wheterh RateLimiter is enabled or disabled for this model for the
      # current request.
      def enabled_for_model(model, value)
        store[:"enabled_for_#{model}"] = value
      end

      # Returns `true` if RateLimiter is enabled for this model for the current
      # request, `false` otherwise.
      def enabled_for_model?(model)
        model.include?(::RateLimiter::Model::InstanceMethods) &&
          !!store.fetch(:"enabled_for_#{model}", true)
      end

      def merge(options)
        options.to_h.each do |k, v|
          store[k] = v
        end
      end

      def set(options)
        store.clear
        merge(options)
      end

      # Returns who is responsible for attempting to create a new record.
      def source
        who = store[:source]
        who.respond_to?(:call) ? who.call : who
      end

      # Sets who is responsible for attempting to create a new record.
      def source=(value)
        store[:source] = value
      end

      # Returns a deep copy of the RequestStore.
      def to_h
        store.deep_dup
      end

      # Temporarily set options and execute a block.
      def with(options)
        return unless block_given?

        before = to_h
        validate_public_options(options)
        merge(options)
        yield
      ensure
        set(before)
      end

      private

      # Internal store for the options for this request.
      def store
        RequestStore.store[:rate_limiter] ||= {
          enabled: true
        }
      end

      # Double checks that the options passed are known. Does not validate
      # the values of the options.
      def validate_public_options(options)
        options.each do |k, _v|
          case k
          when /enabled_for_/,
              :enabled,
              :source
            next
          else
            raise InvalidOption, "Invalid option: #{k}"
          end
        end
      end
    end
  end
end
