# frozen_string_literal: true

# Run in a fresh process so load order and reloading cannot inherit the dummy app.
require 'tmpdir'
require 'fileutils'
require 'json'

controller_type, load_order, loading = ARGV
ENV['RAILS_ENV'] = 'test'

require 'request_store' if load_order == 'request_store_first'
require 'rate_limiter' if load_order == 'gem_first'
require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'

if load_order == 'controllers_first'
  ActionController::Base
  ActionController::API
  ActiveRecord::Base
end

require 'rate_limiter'
require 'rack/mock'

def check(condition, message)
  raise message unless condition
end

def request(app, path)
  status, _headers, body = app.call(Rack::MockRequest.env_for(path))
  text = +''
  begin
    body.each { |part| text << part }
  ensure
    body.close if body.respond_to?(:close)
  end
  check(status == 200, "Unexpected HTTP #{status}: #{text}")
  check(RequestStore.store.empty? && !RequestStore.active?, 'Request state was not cleaned up')
  JSON.parse(text)
end

Dir.mktmpdir('rate-limiter-rails') do |root|
  # Reloading may reconnect Active Record; keep the database across connections.
  ENV['DATABASE_URL'] = "sqlite3:#{root}/test.sqlite3"
  FileUtils.mkdir_p("#{root}/app/models")
  FileUtils.mkdir_p("#{root}/app/controllers")
  File.write("#{root}/app/models/probe_record.rb", <<~RUBY)
    class ProbeRecord < ActiveRecord::Base
      rate_limit on: :identity, interval: 60
    end
  RUBY
  File.write("#{root}/app/controllers/probe_controller.rb", <<~RUBY)
    class ProbeController < ActionController::#{controller_type == 'api' ? 'API' : 'Base'}
      def index
        RateLimiter.request.disable_model(ProbeRecord) if params[:disable_model]
        raise 'Lifecycle failure' if params[:explode]

        render json: {
          enabled: RateLimiter.request.enabled?,
          source: RateLimiter.request.source,
          model_enabled: RateLimiter.request.enabled_for_model?(ProbeRecord)
        }
      end

      protected

      def user_for_rate_limiter
        params[:source]
      end

      def rate_limiter_enabled_for_controller
        super && !params[:disabled]
      end
    end
  RUBY

  app_class = Class.new(Rails::Application) do
    config.load_defaults 8.1
    config.root = root
    config.api_only = controller_type == 'api'
    config.enable_reloading = loading == 'reload'
    config.eager_load = loading == 'eager'
    config.secret_key_base = 'rate-limiter-lifecycle-test-secret'
    config.action_dispatch.show_exceptions = :none
    config.logger = Logger.new(File::NULL)
    config.hosts.clear
  end
  app = app_class.initialize!
  app.routes.draw { get '/probe', to: 'probe#index' }

  check(app.middleware.count { |entry| entry.klass == RequestStore::Middleware } == 1,
        'Expected exactly one request_store middleware')

  ActiveRecord::Schema.verbose = false
  ActiveRecord::Schema.define do
    create_table(:probe_records) do |table|
      table.string :identity
      table.timestamps
    end
  end

  check(request(app, '/probe?source=alice&disable_model=1') ==
        { 'enabled' => true, 'source' => 'alice', 'model_enabled' => false }, 'Controller hooks failed')
  check(request(app, '/probe?disabled=1') ==
        { 'enabled' => false, 'source' => nil, 'model_enabled' => true }, 'Disabled controller state leaked')
  check(request(app, '/probe') ==
        { 'enabled' => true, 'source' => nil, 'model_enabled' => true }, 'Successive request state leaked')

  begin
    request(app, '/probe?source=bob&disable_model=1&explode=1')
    raise 'Expected the request to raise'
  rescue RuntimeError => error
    raise unless error.message == 'Lifecycle failure'
  end
  check(RequestStore.store.empty? && !RequestStore.active?, 'Exception state was not cleaned up')
  check(request(app, '/probe')['model_enabled'], 'Exception affected the next request')

  2.times do
    if loading == 'reload'
      previous_model = ProbeRecord
      previous_controller = ProbeController
      app.reloader.reload!
      check(!ProbeRecord.equal?(previous_model), 'Model was not reloaded')
      check(!ProbeController.equal?(previous_controller), 'Controller was not reloaded')
    end

    app.executor.wrap do
      callbacks = ProbeController._process_action_callbacks.map(&:filter)
      %i[set_rate_limiter_enabled_for_controller set_rate_limiter_source].each do |callback|
        check(callbacks.count(callback) == 1, "Duplicate or missing callback: #{callback}")
      end
      ProbeRecord.delete_all
      check(ProbeRecord.create(identity: 'alice').persisted?, 'Initial record was rejected')
      rejected = ProbeRecord.create(identity: 'alice')
      check(!rejected.persisted? && rejected.errors[:base].length == 1,
            'Expected exactly one rate-limit validation error')
    end
    check(request(app, '/probe?source=carol')['source'] == 'carol', 'Hooks failed after loading')
  end
end

puts "PASS: #{controller_type}, #{load_order}, #{loading}"
