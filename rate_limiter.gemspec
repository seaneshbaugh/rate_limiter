# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require 'rate_limiter/version'

Gem::Specification.new do |s|
  s.name        = 'rate_limiter'
  s.version     = RateLimiter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.author      = 'Sean Eshbaugh'
  s.email       = 'seaneshbaugh@gmail.com'
  s.homepage    = 'https://github.com/seaneshbaugh/rate_limiter'
  s.summary     = 'Adds creation rate limiting to ActiveRecord models.'
  s.description = 'Adds creation rate limiting to ActiveRecord models.'

  s.required_ruby_version = '~> 4.0.0'

  s.files         = Dir['lib/**/*', 'CHANGELOG.md', 'LICENSE.txt', 'README.md', 'rate_limiter.gemspec']
  s.executables   = []
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '~> 8.1.0'
  s.add_dependency 'railties', '~> 8.1.0'
  s.add_dependency 'request_store', '~> 1.7'

  # Keep the existing harness on Minitest 5 while modernizing the test app.
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'minitest-spec-rails', '~> 7.4'
  s.add_development_dependency 'puma', '~> 8.0'
  s.add_development_dependency 'rails', '8.1.4.1'
  s.add_development_dependency 'rake', '~> 13.3'
  s.add_development_dependency 'rubocop', '~> 1.92'
  s.add_development_dependency 'simplecov', '~> 1.3'
  s.add_development_dependency 'sqlite3', '~> 2.10'
  s.add_development_dependency 'timecop', '~> 0.9.11'
end
