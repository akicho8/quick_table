$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "quick_table/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "quick_table"
  s.version     = QuickTable::VERSION
  s.authors     = ["akicho8"]
  s.email       = ["akicho8@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of QuickTable."
  s.description = "Description of QuickTable."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
