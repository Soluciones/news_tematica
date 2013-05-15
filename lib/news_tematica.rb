require "news_tematica/engine"

module NewsTematica
  module Clases
    %w(newsletter_helper tematica contenido tagging antifail).each do |klass|
      mattr_accessor klass

      define_method "#{klass}_class" do
        ::NewsTematica::Clases.send(klass).constantize
      end
    end
  end
end

