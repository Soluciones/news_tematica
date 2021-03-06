$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'news_tematica/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'news_tematica'
  s.version     = NewsTematica::VERSION
  s.authors     = ['Fernan2 & Abby - Rankia']
  s.email       = ['fernando@rankia.com']
  s.homepage    = 'https://github.com/Soluciones/news_tematica'
  s.summary     = 'Permite crear newsletters tematicas y enviarlas por Mandrill.'
  s.description = 'Se apoya en Tematica.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.4'

  # Gema para transformar bello HTML y CSS en odioso código para emails
  s.add_dependency 'premailer-rails'
  s.add_dependency 'nokogiri'
  s.add_dependency 'will_paginate'

  s.add_dependency 'haml-rails'
  s.add_dependency 'sass'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'draper'
  s.add_dependency 'aws-s3'
end
