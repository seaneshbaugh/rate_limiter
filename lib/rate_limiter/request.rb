# frozen_string_literal: true

require 'request_store'

module RateLimiter
  module Request
    class InvalidOption < RuntimeError
    end

    class << self
      def disable_model(model_class)
        enabled_for_model(model_class, false)
      end

      def enable_model(model_class)
        enabled_for_model(model_class, true)
      end

      def enabled?
        !!store[:enabled]
      end

      def enabled=(value)
        store[:enabled] = value
      end

      def enabled_for_model(model, value)
        store[:"enabled_for_#{model}"] = value
      end

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

      def source
        who = store[:source]
        who.respond_to?(:call) ? who.call : who
      end

      def source=(value)
        store[:source] = value
      end

      def to_h
        store.deep_dup
      end

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

      def store
        RequestStore.store[:rate_limiter] ||= {
          enabled: true
        }
      end

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
