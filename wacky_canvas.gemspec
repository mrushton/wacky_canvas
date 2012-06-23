$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wacky_canvas/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wacky_canvas"
  s.version     = WackyCanvas::VERSION
  s.authors     = ["Matt Rushton"]
  s.email       = ["mrushton7@yahoo.com"]
  s.homepage    = "http://www.wackywordsfriends.com"
  s.summary     = "Rails 3 engine gem for Facebook canvas app authorization."
  s.description = "Wacky Canvas is a Rails 3 engine gem extracted from Wacky Words Friends for handling Facebook canvas app authorization. It records various stats for easy testing of new ideas and features."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.5"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
