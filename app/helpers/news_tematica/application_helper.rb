module NewsTematica
  module ApplicationHelper
    def max_caracteres_con_palabras_enteras(frase, ncar)
      frase.match(/\A.{0,#{ncar - 1}}\b/m)[0].strip
    end

    def link_to_con_estadisticas(texto, destino, news_tematica, opciones = {})
      if news_tematica.save
        redireccion = news_tematica.redirections.find_or_create_by url: destino
        link_to texto, "http://#{request.host}/redirections/#{redireccion.id}", opciones
      end
    end
  end
end

