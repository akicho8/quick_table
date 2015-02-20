# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_table/version'

Gem::Specification.new do |spec|
  spec.name          = "quick_table"
  spec.version       = QuickTable::VERSION
  spec.authors       = ["akicho8"]
  spec.email         = ["akicho8@gmail.com"]
  spec.description   = %q{object to html library for rails desu}
  spec.summary       = %q{object to html library for rails}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "psych"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"

  spec.add_dependency "rails"
  spec.add_dependency "actionpack"
  spec.add_dependency "activesupport"
  spec.add_dependency "sass-rails"
end
