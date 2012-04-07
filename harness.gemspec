# -*- encoding: utf-8 -*-
require File.expand_path('../lib/harness/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["twinturbo"]
  gem.email         = ["me@broadcastingadam.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "harness"
  gem.require_paths = ["lib"]
  gem.version       = Harness::VERSION
end
