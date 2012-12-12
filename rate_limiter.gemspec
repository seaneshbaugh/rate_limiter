# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'rate_limiter/version'

Gem::Specification.new do |s|
  s.name        = 'rate_limiter'
  s.version     = RateLimiter::VERSION
  s.authors     = ['Sean Eshbaugh']
  s.email       = ['seaneshbaugh@gmail.com']
  s.homepage    = 'https://github.com/seaneshbaugh/rate_limiter'
  s.summary     = 'Adds creation rate limiting to ActiveRecord models.'
  s.description = 'Adds creation rate limiting to ActiveRecord models.'

  s.rubyforge_project = 'rate_limiter'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'railties', '~> 3.0'
  s.add_dependency 'activerecord', '~> 3.0'

  s.add_development_dependency 'rspec'
end
