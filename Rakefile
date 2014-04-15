#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
end

task :mutant do
  sh "bundle exec mutant -I lib -r harness --use minitest '::Harness'"
end

task :default => :test
