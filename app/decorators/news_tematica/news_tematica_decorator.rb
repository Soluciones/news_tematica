module NewsTematica
  class NewsTematicaDecorator < Draper::Decorator
    include Clases
    delegate_all

    def html_con_contadores
      doc = Nokogiri::HTML(source.html)
      doc.css('a').select{ |link| link['href'].match /\/redirections\// }.each do |link|
        redirection_id = link['href'].split('/').last
        contador_visitas = visita_class.where(redirection_id: redirection_id).count.to_s
        span = doc.create_element("span", contador_visitas, class: 'cuentaclics')
        link.add_previous_sibling(span)
      end
      doc.css('body').inner_html
    end

    # Los titulares se apoyan en la sección de titulares, si hay, o si no en la etiqueta correspondiente
    def titulares
      if source.suscribible.try(:seccion_titulares).present?
        q = contenido_class.where("#{ source.suscribible.seccion_titulares } = true").where(created_at: source.fecha_desde..source.fecha_hasta).where(fecha_titulares: source.fecha_desde..source.fecha_hasta)
      elsif source.suscribible.try(:tag_id)
        taggings = tagging_class
                     .where(tag_id: source.suscribible.tag_id)
                     .where(created_at: source.fecha_desde..source.fecha_hasta)
                     .where(fecha_titulares: source.fecha_desde..source.fecha_hasta)
        q = contenido_class.where(id: taggings.map(&:taggable_id))
      else
        q = contenido_class
              .where(created_at: source.fecha_desde..source.fecha_hasta)
              .where(fecha_titulares: source.fecha_desde..source.fecha_hasta)
      end
      prioriza q.publicado.in_locale('es').includes(:fotos, :veces_leido, :blog)
    end

    # Lo más leído se apoyará en los scopes de las portadas temáticas
    def lo_mas_leido
      msgs = contenido_class.publicado.in_locale('es').includes(:veces_leido, :blog).where(created_at: source.fecha_desde..source.fecha_hasta)
      msgs = msgs.send("de_#{ source.suscribible.scope_lo_mas_leido }".to_sym) if source.suscribible.try(:scope_lo_mas_leido).present?
      msgs.sort_by { |msg| 100 - msg.contador_veces_leido * msg.factor_corrector_para_nuevos }
    end

    # Los foros pueden ser foros principales (basados en subtipo_id) o foros temáticos (basados en tag_id)
    def temas
      if source.suscribible.try(:subtipo_id)
        q = contenido_class
          .where(tema: source.suscribible.subtipo_id)
          .where(created_at: source.fecha_desde..source.fecha_hasta)
      elsif source.suscribible.try(:tag_id)
        taggings = tagging_class
                  .where(tag_id: source.suscribible.tag_id)
                  .where(tema: Subtipo::ARRAY_FOROS_NORMALES)
                  .where(created_at: source.fecha_desde..source.fecha_hasta)
        q = contenido_class.where(id: taggings.map(&:taggable_id))
      else
        q = contenido_class.where(tema: Subtipo::ARRAY_FOROS_NORMALES).where(created_at: source.fecha_desde..source.fecha_hasta)
      end
      prioriza q.publicado.in_locale('es').includes(:veces_leido, :blog)
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
      max_veces_leido = evita_error_divbyzero(contenidos.max_by { |msg| msg.contador_veces_leido }.contador_veces_leido.to_f)
      max_respuestas = evita_error_divbyzero(contenidos.max_by(&:respuestas_count).respuestas_count.to_f)
      contenidos.each { |msg| msg.cotizacion = (10 * (msg.votos_count/max_votos) + 3 * (msg.contador_veces_leido/max_veces_leido) + 6 * (msg.respuestas_count/max_respuestas)) * msg.factor_corrector_para_nuevos }
      contenidos.sort_by { |msg| 100 - msg.cotizacion }
    end

    def prioriza_como_te_diga(contenidos, prioridades)
      prioridades_ordenadas = prioridades.sort_by{ |_, orden| orden.to_i }
      contenidos_ordenados = prioridades_ordenadas.map {|id, _| contenidos.select { |contenido| contenido.id == id.to_i }.first }
      contenidos_ordenados.compact
    end

    def evita_error_divbyzero(dato)
      dato.zero? ? 1.0 : dato
    end

    def titulo_generico
      general? ? "News de #{ESTA_WEB}" : "News temática de #{suscribible.nombre}"
    end

    def titulo_de_foro
      general? ? 'Foros' : "Foro de #{ suscribible.nombre }"
    end
  end
end
