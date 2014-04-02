# coding: UTF-8

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "news_tematica/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "news_tematica"
  s.version     = NewsTematica::VERSION
  s.authors     = ["Fernan2 & Abby - Rankia"]
  s.email       = ["fernando@emergia.net"]
  s.homepage    = "https://github.com/Soluciones/news_tematica"
  s.summary     = "Permite crear newsletters temáticas y enviarlas por SendGrid."
  s.description = "Se apoya en los modelos Suscripcion y Tematica."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.12"

  # Gema para transformar bello HTML y CSS en odioso código para emails
  s.add_dependency 'premailer-rails'
  s.add_dependency 'nokogiri'

  s.add_dependency 'haml-rails'
  s.add_dependency 'sass-rails', '~> 3.1.0'
  s.add_dependency 'draper'

  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'mysql2'

  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'guard-rspec'
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

  s.add_development_dependency 'mailcatcher' # Set your app to deliver to smtp://127.0.0.1:1025 instead of your default SMTP server, then check out http://127.0.0.1:1080 to see the mail.
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'rspec-rails' # Neceario para crear los specs automáticamente con los comandos 'rails generate'

end
