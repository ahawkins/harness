# -*- encoding: utf-8 -*-
require File.expand_path('../lib/harness/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["twinturbo"]
  gem.email         = ["me@broadcastingadam.com"]
  gem.description   = %q{Log ActiveSupport::Notifications to various services like Librato or StatsD}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/twinturbo/harness"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "harness"
  gem.require_paths = ["lib"]
  gem.version       = Harness::VERSION

  gem.add_dependency "activesupport", "~> 3"
  gem.add_dependency "redis"
  gem.add_dependency "redis-namespace"

  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "resque"
  gem.add_development_dependency "sidekiq"
  gem.add_development_dependency "delayed_job_active_record"
  gem.add_development_dependency "active_model_serializers"
  gem.add_development_dependency "rails", "~> 3"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "statsd-instrument"
end
