require "news_tematica/engine"

module NewsTematica
  module Clases
    %w(newsletter_helper tematica contenido tagging antifail).each do |klass|
      mattr_accessor "#{klass}_extern"

      define_method "#{klass}_class" do
        ::NewsTematica::Clases.send("#{klass}_extern").constantize
      end
    end
  end
end

