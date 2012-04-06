$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "headcount/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "headcount"
  s.version     = Headcount::VERSION
  s.authors     = ["Ryan Mohr"]
  s.email       = ["ryan.mohr@gmail.com"]
  s.homepage    = "http://github.com/kumu/headcount"
  s.summary     = "A simple stat collector for rails apps"
  s.description = ""

  s.rubyforge_project = "headcount"
  
  s.files         = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Gemfile", "Gemfile.lock", "Rakefile", "README.md", "CHANGELOG.md"]
  # s.test_files    = Dir["{spec}/**/*"] # don't force everyone to also have to download the tests and dummy app
  s.require_paths = ["lib"]
  
  s.add_dependency "rails", "~> 3.2.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "spork"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
end