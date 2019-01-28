# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

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

  s.required_ruby_version     = '>= 2.5.0'
  s.required_rubygems_version = '>= 1.8.11'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '>= 5.0.0'
  s.add_dependency 'railties', '>= 5.0.0'

  s.add_development_dependency 'minitest', '5.11.3'
  s.add_development_dependency 'rails', '5.2.2'
  s.add_development_dependency 'rake', '12.3.2'
  s.add_development_dependency 'rubocop', '0.63.1'
  s.add_development_dependency 'sqlite3', '1.3.13'
end
