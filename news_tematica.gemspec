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

  s.add_dependency "rails", "~> 3.2.17"

  # Gema para transformar bello HTML y CSS en odioso código para emails
  s.add_dependency 'premailer-rails'
  s.add_dependency 'nokogiri'

  s.add_dependency 'haml-rails'
  s.add_dependency 'sass', '3.2.14'
  s.add_dependency 'draper'
  s.add_dependency 'aws-s3'

  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'mysql2'

  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'rspec-instafail'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'rspec-rails'
end
