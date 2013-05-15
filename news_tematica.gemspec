$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "news_tematica/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "news_tematica"
  s.version     = NewsTematica::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of NewsTematica."
  s.description = "TODO: Description of NewsTematica."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.12"

  # Gema para transformar bello HTML y CSS en odioso código para emails
  s.add_dependency 'premailer-rails'

  s.add_dependency 'haml-rails'
  s.add_dependency 'sass'
  s.add_dependency 'draper'
  s.add_dependency 'marginalia'

  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'mysql2'

  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'active_reload'

  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-jasmine'
  s.add_development_dependency 'guard-jasmine-headless-webkit'
  s.add_development_dependency 'rb-inotify'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'rb-fchange'

  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'rspec-instafail'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'launchy'

end
