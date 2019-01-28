# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

desc 'Default: run tests.'
task default: :test

desc 'Run RateLimiter tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
  t.warning = false
end
