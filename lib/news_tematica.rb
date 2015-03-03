require "news_tematica/engine"
require 'draper'
require 'haml'
require 'coffee-rails'
require 'jquery-rails'

module NewsTematica
  module Clases
    %w(tematica redirection contenido tagging antifail visita).each do |klass|
      mattr_accessor "#{klass}_extern"

      define_method "#{klass}_class" do
        ::NewsTematica::Clases.send("#{klass}_extern").constantize
      end
    end
  end

  module Personalizacion
    mattr_accessor :logo, :dominio, :twitter_url, :facebook_url, :email_contacto
  end
end

