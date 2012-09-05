# -*- encoding: utf-8 -*-
require File.expand_path('../lib/icy_divine/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Carroll"]
  gem.email         = ["michael@aqua.io"]
  gem.description   = %q{A set of Rake tools for seeding the ICD specifications you want where you want them.}
  gem.summary       = %q{Extract ICD code specifications by year and automagically seed them in your database.}
  gem.homepage      = "https://github.com/mikecarroll/icy_divine.git"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "icy_divine"
  gem.require_paths = ["lib"]
  gem.version       = IcyDivine::VERSION

  #gem.add_development_dependency "rspec"
end
