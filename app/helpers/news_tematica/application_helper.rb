module NewsTematica
  module ApplicationHelper
    def link_to_con_estadisticas(texto, destino, news_tematica, opciones = {})
      if news_tematica.save
        redireccion = news_tematica.redirections.find_or_create_by url: destino
        link_to texto, "http://#{request.host}/redirections/#{redireccion.id}", opciones
      end
    end

    def dominios
      Personalizacion.dominios || [:es]
    end
  end
end
