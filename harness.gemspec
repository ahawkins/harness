# -*- encoding: utf-8 -*-
require File.expand_path('../lib/harness/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ahawkins"]
  gem.email         = ["adam@hawkins.io"]
  gem.description   = %q{Collect high level application performance metrics and forward them for analysis}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/ahawkins/harness"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "harness"
  gem.require_paths = ["lib"]
  gem.version       = Harness::VERSION

  gem.add_dependency "statsd-ruby"

  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "rake"
end
