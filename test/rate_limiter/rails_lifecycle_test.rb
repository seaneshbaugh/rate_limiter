# frozen_string_literal: true

require 'test_helper'
require 'open3'
require 'rbconfig'

module RateLimiter
  class RailsLifecycleTest < ActiveSupport::TestCase
    %w[standard api].each do |controller_type|
      %w[gem_first controllers_first request_store_first].each do |load_order|
        test "#{controller_type} controllers with #{load_order} and eager loading" do
          assert_lifecycle(controller_type, load_order, 'eager')
        end
      end

      test "#{controller_type} controllers survive repeated reloads" do
        assert_lifecycle(controller_type, 'rails_first', 'reload')
      end
    end

    test 'model integration works outside a Rails application' do
      program = <<~RUBY
        require 'active_record'
        ActiveRecord::Base
        require 'rate_limiter'
        abort 'Unexpected application' if Rails.respond_to?(:application) && Rails.application
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
        ActiveRecord::Schema.verbose = false
        ActiveRecord::Schema.define do
          create_table(:standalone_records) do |table|
            table.string :ip_address
            table.timestamps
          end
        end
        class StandaloneRecord < ActiveRecord::Base
          rate_limit
        end
        abort 'First create failed' unless StandaloneRecord.create(ip_address: '127.0.0.1').persisted?
        abort 'Second create allowed' if StandaloneRecord.create(ip_address: '127.0.0.1').persisted?
      RUBY
      output, status = Open3.capture2e(
        RbConfig.ruby, '-Ilib', '-e', program,
        chdir: File.expand_path('../..', __dir__)
      )
      assert status.success?, output
    end

    private

    def assert_lifecycle(controller_type, load_order, loading)
      output, status = Open3.capture2e(
        RbConfig.ruby, '-Ilib', 'test/support/rails_lifecycle.rb',
        controller_type, load_order, loading,
        chdir: File.expand_path('../..', __dir__)
      )
      assert status.success?, output
    end
  end
end
