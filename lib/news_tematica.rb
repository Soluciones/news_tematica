require "news_tematica/engine"

module NewsTematica
  module Clases
    %w(newsletter_helper tematica redirection contenido tagging antifail visita).each do |klass|
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

