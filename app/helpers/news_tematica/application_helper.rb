module NewsTematica
  module ApplicationHelper
    def max_caracteres_con_palabras_enteras(frase, ncar)
      frase.match(/\A.{0,#{ncar - 1}}\b/m)[0].strip
    end

    def link_to_con_estadisticas(texto, destino, config = {}, opciones = {})
      redireccion = config[:news_tematica].redirections.find_or_create_by_url(destino)
      link_to texto, "http://#{config[:host]}/redirections/#{redireccion.id}", opciones
    end

    def perfil_url(nick_limpio)
      "#{request.protocol}#{request.host_with_port}/usuarios/#{nick_limpio}"
    end
  end
end

