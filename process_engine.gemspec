$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "process_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "process_engine"
  s.version     = ProcessEngine::VERSION
  s.authors     = ["Chris Moody"]
  s.email       = ["cmoody.eit@gmail.com"]
  s.homepage    = "https://github.com/cmoodyEIT/process_engine"
  s.summary     = "Process Engineering."
  s.description = "Process Engineering."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.2"
  s.add_dependency "pg",    "~> 0.21"

end
