# coding: UTF-8

module NewsTematica
  class NewsTematicaDecorator < Draper::Decorator
    include Clases
    delegate_all

    def html_con_contadores
      cachos = source.html.split('/redirections/')
      fin_de_link_de_redirection = /((\d+).*">)/
      cachos[1..-1].each_with_index do |cacho_con_redirection, i|
        cacho_con_redirection.match fin_de_link_de_redirection
        cachos[i + 1] = cacho_con_redirection.sub(fin_de_link_de_redirection, '\1<span class="cuentaclics">' + visita_class.where(redirection_id: $2.to_i).count.to_s + '</span>')
      end
      cachos.join('/redirections/')
    end

    # Los titulares se apoyan en la sección de titulares, si hay, o si no en la etiqueta correspondiente
    def titulares
      if source.tematica.seccion_titulares.present?
        q = contenido_class.where("#{ source.tematica.seccion_titulares } = true").where(created_at: source.fecha_desde..source.fecha_hasta).where(fecha_titulares: source.fecha_desde..source.fecha_hasta)
      elsif source.tematica.tag_id
        taggings = tagging_class.where(tag_id: source.tematica.tag_id).where(created_at: source.fecha_desde..source.fecha_hasta).where(fecha_titulares: source.fecha_desde..source.fecha_hasta)
        q = contenido_class.where(id: taggings.map(&:taggable_id))
      else
        antifail_class.create(tipo: 'Temática sin titulares configurados', detalles: source.tematica.inspect)
        return nil
      end
      prioriza q.publicado.in_locale('es').includes(:fotos, :veces_leido, :blog).all
    end

    # Lo más leído se apoyará en los scopes de las portadas temáticas
    def lo_mas_leido
      contenido_class.publicado.in_locale('es').includes(:veces_leido, :blog).where(created_at: source.fecha_desde..source.fecha_hasta).send("de_#{ source.tematica.scope_mas_leido }".to_sym).all.sort_by { |msg| 100 - msg.veces_leido.contador * msg.factor_corrector_para_nuevos }
    end

    # Los foros pueden ser foros principales (basados en subtipo_id) o foros temáticos (basados en tag_id)
    def temas
      if source.tematica.subtipo_id
        q = contenido_class.where(tema: source.tematica.subtipo_id).where(created_at: source.fecha_desde..source.fecha_hasta)
      elsif source.tematica.tag_id
        taggings = tagging_class.where(tag_id: source.tematica.tag_id).where(tema: Subtipo::ARRAY_FOROS_NORMALES).where(created_at: source.fecha_desde..source.fecha_hasta)
        q = contenido_class.where(id: taggings.map(&:taggable_id))
      else
        antifail_class.create(tipo: 'Temática sin foro configurado', detalles: source.tematica.inspect)
        return nil
      end
      prioriza q.publicado.in_locale('es').includes(:veces_leido, :blog).all
    end

    def banner_lateral
      { url_imagen: source.banner_1_url_imagen, texto_alt: source.banner_1_texto_alt, url_destino: source.banner_1_url_destino }
    end

    def banner_inferior
      { url_imagen: source.banner_2_url_imagen, texto_alt: source.banner_2_texto_alt, url_destino: source.banner_2_url_destino }
    end

    def prioriza(contenidos)
      return [] if contenidos.blank?
      max_votos = evita_error_divbyzero(contenidos.max_by(&:votos_count).votos_count.to_f)
      max_veces_leido = evita_error_divbyzero(contenidos.max_by { |msg| msg.veces_leido.contador }.veces_leido.contador.to_f)
      max_respuestas = evita_error_divbyzero(contenidos.max_by(&:respuestas_count).respuestas_count.to_f)
      contenidos.each { |msg| msg.cotizacion = (10 * (msg.votos_count/max_votos) + 3 * (msg.veces_leido.contador/max_veces_leido) + 6 * (msg.respuestas_count/max_respuestas)) * msg.factor_corrector_para_nuevos }
      contenidos.sort_by { |msg| 100 - msg.cotizacion }
    end

    def evita_error_divbyzero(dato)
      dato.zero? ? 1.0 : dato
    end
  end
end
