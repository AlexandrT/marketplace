$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "marketplace/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "marketplace"
  s.version     = Marketplace::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Marketplace."
  s.description = "TODO: Description of Marketplace."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"
end
