# coding: UTF-8

#-----------------------------------------------------------------------------------------------#
#------------------ CACHÉ - Funciones que hacen cacheo de datos para ahorrar consultas ---------#
#-----------------------------------------------------------------------------------------------#
# Un dato se tiene que escribir si
#   - No está cacheado
#   - Si es periódico y pasó el tiempo máximo
# En modo development no debe cachear, da problemas
# Modos soportados: GET, POST, DELETE
#-----------------------------------------------------------------------------------------------#
def mi_cache(dato, modo = nil, modificador = '', clase = '')
  cache_id = "#{dato}#{clase}#{modificador}"
  if Rails.cache.class == ActiveSupport::Cache::FileStore
    # Este es el modo que usaremos para indicar "no caché", ya que no nos va null_store
    calcula_cache(dato, modo, modificador, cache_id)
  elsif (modo == 'DELETE')
    Rails.cache.delete(cache_id)
    Rails.cache.delete("#{cache_id}_updated_at")
  else
    if ((modo == 'POST') or ((modo == 'PERIODICO') and !actualizado(cache_id)) or !Rails.cache.read(cache_id))
      resultado = calcula_cache(dato, modo, modificador, cache_id)
      # No nos guardamos en caché los usuarios con pocas aportaciones
      Rails.cache.write(cache_id, resultado) if ((cache_id != 'usuario') or (resultado.puntos > 100)) and !Rails.env.test?
      resultado
    else
      Rails.cache.read(cache_id)
    end
  end
end

def actualizado(cache_id)
  (Rails.cache.read("#{cache_id}_updated_at") and (Rails.cache.read("#{cache_id}_updated_at") > 10.minutes.ago))
end

def calcula_cache(dato, modo, modificador, cache_id)
  # Si el dato es periódico se apunta la última modificación.
  # Aquí se usa Time.now porque por ahora queremos que todas las cachés sean idénticas en cualquier dominio.
  # Ya se personalizan a nivel del "modificador" con I18n.locale
  Rails.cache.write("#{cache_id}_updated_at", Time.now) if (modo == 'PERIODICO')

  case dato
    # --- Todas las webs ---#
    when 'banners_publi'
      Banner.dame_banners(["v.seccion = ?", modificador.blank? ? 'otros' : modificador])
    when 'banners_publi_cabecera'
      Banner.dame_cabeceras(modificador.blank? ? 'otros' : modificador)
    when 'blogs_etiquetas'
      # Recibe en modificador dos parámetros: el blog (id del blog, o lista de ids separada por comas, o 'blogs', o vacío si es toda la web) y el nº de registros. Ej: 'blogs-30', '43-20', '11,13,56-20' o '-100'
      blog, n_tags = modificador.split('-')

      if blog == 'blogs'
        sel = Tag.campos_nube_en_blogs
      elsif blog.present?
        sel = Tag.campos_nube_en_blog(blog.to_i)
      else
        sel = Tag.campos_nube
      end
      sel.limit(n_tags.to_i).all
    when 'etiquetas_permitidas'
      Tag.campos_nube.where('tags.permalink in (?)', modificador.split(',')).all
    when 'blogs_masleidos'
      q = Post.select('contenidos.titulo, contenidos.contenido_link, contenidos.subtipo_id, contenidos.blog_id').con_veces_leido
      q = modificador.is_a?(Numeric) ? q.where('contenidos.blog_id = ?', modificador) : q.in_locale(modificador).where('contenidos.created_at > ?', 1.month.ago)
      q.where("contenidos.tema = ?", Subtipo::POSTS).order('veces_leidos.contador DESC').limit(10).all
    when 'blogs_masrecomendados'
      Post.where("blog_id IS NOT NULL AND tema = #{Subtipo::POSTS}").mas_votados(10).in_locale(modificador).all
    when 'usuario'
      Usuario.select('id, nick, nick_limpio, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, puntos').find(modificador)
    when 'contenido_mas_leidos_dia'
      # En conditions le digo que no me interesa nada de AFINSA
      Contenido.select('titulo, contenido_link, contenidos.created_at, veces_leidos.leido_dia').con_veces_leido.where('contenidos.created_at > ?', 7.days.ago).publicado.in_locale(modificador).where("subtipo_id NOT IN (#{Subtipo::AFINSA},#{Subtipo::ARRAY_FOROS_PRIVADOS.join(',')})").order("veces_leidos.leido_dia DESC").limit(10).all
    when 'contenido_mas_leidos_semana'
      Contenido.select('titulo, contenido_link, contenidos.created_at, veces_leidos.leido_semana').con_veces_leido.where('contenidos.created_at > ?', 7.days.ago).publicado.in_locale(modificador).where("subtipo_id NOT IN (#{Subtipo::AFINSA},#{Subtipo::ARRAY_FOROS_PRIVADOS.join(',')})").order("veces_leidos.leido_semana DESC").limit(10).all
    when 'num_foros_tematicos'
      Tag.in_locale(modificador).sin_subtipo.count
    when 'blogs_destacados'
      id = Pais.find_by_codigo_iso(modificador).id
      Blog.select('id, titulo, nombre_corto, descripcion, url').where('orden_subnav IS NOT NULL').order("IF(pais_id = #{id}, 1, 2), orden_subnav").all
    when 'blogs_de_analisis_fundamental'
      urls = []
      urls << 'invirtiendo-en-empresas'
      urls << 'oraculo-omaha'
      urls << 'analisis-value'
      urls << 'analisis-cogninvestivo'
      urls << 'analisis-fundamental'
      urls << 'anfundeem'
      urls << 'small-is-more'
      Blog.select('id, titulo, nombre_corto, descripcion, url').where(url: urls).all
    when 'blogs_de_economia'
      urls = []
      urls << 'nuevasreglaseconomia'
      urls << 'comstar'
      urls << 'oikonomia'
      urls << 'macroymicroblog'
      urls << 'ipc'
      urls << 'tasa-paro'
      urls << 'euribor'
      urls << 'economia-domestica'
      Blog.select('id, titulo, nombre_corto, descripcion, url').where(url: urls).all
    when 'blogs_por_seccion_publi'
      locale, seccion = modificador.split(',')
      pais = Pais.find_by_codigo_iso(locale)
      id = pais ? pais.id : 1
      Blog.select('id, titulo, nombre_corto, descripcion, url').where(estado_id: 1).where(seccion_banner: seccion).order("IF(pais_id = #{id}, 1, 2), IFNULL(orden_subnav,9999), posts_count DESC").all
    when 'ids_blogs_por_seccion_publi'
      mi_cache('blogs_por_seccion_publi', 'GET', modificador).collect{|blog| blog.id}
    when 'ids_blogs_por_seccion_publi_SQL'
      ids = mi_cache('ids_blogs_por_seccion_publi', 'GET', modificador)
      ids.empty? ? 'NULL' : ids.join(', ')
    when 'blogs_ultimos_posts'
      n, locale = modificador.to_s.split(',')
      filtro = Post.where(tema: Subtipo::POSTS).where('created_at < UTC_TIMESTAMP()')
      filtro = filtro.in_locale(locale) if locale
      filtro.select('id, titulo, contenido_link, respuestas_count, created_at, blog_id, fecha_titulares').order('created_at DESC').limit(n).all
    when 'subtipos_todo'
      Subtipo.select('id, nombre, nombre_completo, nombre_corto, nombre_mediocorto, url, seccion_banner').all
    when 'nombres_subtipos'
      Hash[*mi_cache('subtipos_todo').collect { |v|  [v.id, v.nombre] }.flatten]
    when 'nombres_completos_subtipos'
      Hash[*mi_cache('subtipos_todo').collect { |v|  [v.id, v.nombre_completo] }.flatten]
    when 'nombres_cortos_subtipos'
      Hash[*mi_cache('subtipos_todo').collect { |v|  [v.id, v.nombre_corto] }.flatten]
    when 'nombres_mediocortos_subtipos'
      Hash[*mi_cache('subtipos_todo').collect { |v|  [v.id, v.nombre_mediocorto] }.flatten]
    when 'paises_todo'
      Pais.select('id, nombre').all
    when 'paises_con_dominio'
      Pais.select('id, nombre, codigo_iso').con_dominio.order("IF(codigo_iso = 'es', 0, 1), nombre").all
    when 'paises_nombre'
      Hash[*mi_cache('paises_todo').collect { |p|  [p.id, p.nombre] }.flatten]
    when 'paises_desplegable'
      mi_cache('paises_todo').collect {|p| [ p.nombre, p.id ] }
    when 'provincias_todo'
      Provincia.select('id, nombre').where('id < 53').order('nombre').all
    when 'provincias_nombre'
      Hash[*mi_cache('provincias_todo').collect { |p|  [p.id, p.nombre] }.flatten]
    when 'provincias_desplegable'
      mi_cache('provincias_todo').collect {|p| [ p.nombre, p.id ] }
    when 'secciones_banner'
      Hash[*mi_cache('subtipos_todo').collect { |v|  [v.id, v.seccion_banner] }.flatten]
    when 'tipo_prods'
      Hash[*TipoProducto.select('id, nombre').all.collect { |v|  [v.id, v.nombre] }.flatten]
    when 'urls_subtipos'
      Hash[*mi_cache('subtipos_todo').collect { |v|  [v.id, v.url] }.flatten]
    # --- webs grandes ---#
    when 'num_usuarios'
      Usuario.count
    when 'mi_cartera_connect'
      Constante.first.mi_cartera_connect
    when 'fbconnect'
      Constante.first ? Constante.first.fbconnect : false
    when 'twconnect'
      Constante.first ? Constante.first.twconnect : false
    when 'csconnect'
      Constante.first ? Constante.first.csconnect : false
    when 'm1connect'
      Constante.first ? Constante.first.m1connect : false
    when 'fragmentosconnect'
      true
    when 'captadorconnect'
      Constante.first ? Constante.first.captadorconnect : false
    # --- específico esta web ---#
    when 'actualidad_y_guia_basica'
      pagestatica = Pagestatica.find_by_bloque_and_permalink('xanadu', modificador)
      pagestatica ? pagestatica.html : ''
    when 'categorias_de_foros_tematicos'
      q = Tag.select('DISTINCT categoria').sin_subtipo
      q = q.in_locale(modificador) if modificador.present?
      q.order('categoria').all.collect{ |r| r.categoria }.select{ |t| t.present? }
    when 'hash_categorias_de_foros_tematicos' # Convierte ['Depósitos', 'Hipotecas'] en { 'depositos' => 'Depósitos', 'hipotecas' => 'Hipotecas']}
      a = mi_cache('categorias_de_foros_tematicos', 'GET', modificador)
      Hash[a.collect{ |txt| txt.tag2url }.zip(a)]
    when 'hash_carpetas_de_foros_tematicos'
      a = Tag.select('DISTINCT carpeta').in_locale(modificador).sin_subtipo.order('carpeta').all.collect{ |r| r.carpeta }.select{ |t| t.present? }
      Hash[a.collect{ |txt| txt.tag2url }.zip(a)]
    when 'home_bloque_blogs'
      Blog.where('estado_id = ?', Blog::ESTADO_ACTIVO).order("IF(pais_id = #{Pais.find_by_codigo_iso(modificador).id}, 1, 2), created_at desc").limit(10).all
    when 'home_bloque_foros'
      Subtipo.select('c.titulo, c.contenido_link, nombre, url').joins('INNER JOIN contenidos c on subtipos.ultimo_producto_tema = c.id').where("subtipos.id in (#{Subtipo::FOROS_EN_HOME})").order('subtipos.position').all
    when 'home_bloque_foros_fijos'
      result = {}
      Subtipo::ARRAY_FOROS_VISIBLES[modificador].each do |foro|
        result[foro] = Contenido.where(tema: foro).ultimos(5).all
      end
      result
    when 'home_bloque_foros_acciones'
      Tag.acciones_bolsa(5)
    when 'home_bloque_foros_acciones_fijos'
      foros_acciones_latam = %w(apple-aapl facebook-fb mcdonalds-mcd coca-cola-ko berkshire-hathaway-brk-a citigroup-c google-goog)
      Tag.where("subtipo_id = #{Subtipo::BOLSA} AND name LIKE '%)'").where(permalink: foros_acciones_latam).order('IFNULL(prioridad, 9999), visitas_recientes DESC').all
    when 'home_bloque_foros_tematicos'
      Tag.select('tags.name, tags.permalink')
        .joins(:subtipo)
        .in_locale(modificador)
        .where("(subtipo_id <> #{Subtipo::BOLSA}) OR (tags.name NOT LIKE '%)')")
        .order("IF(subtipos.pais_id = #{Pais.find_by_codigo_iso(modificador).id}, 1, 2), IFNULL(tags.prioridad, 9999), visitas_recientes DESC")
        .limit(7).all
    when 'home_bloque_opiniones'
      Subtipo.all(:select => "c.titulo, c.contenido_link, nombre_corto, url, p.nombre, p.producto_link",
                  :joins => "INNER JOIN contenidos c on subtipos.ultimo_contenido = c.id
                            INNER JOIN productos p on c.producto_id = p.id",
                  :conditions => "subtipos.id in (#{Subtipo::LISTA_OPINIONES}) and c.publicado = true and p.publicado = true",
                  :order => "subtipos.ultimo_contenido desc", :limit => 3)
    when 'home_titulares'
      pagina, locale = modificador.split('_')
      Contenido.titulares_en_abierto.publicado.in_locale(locale).paginate(total_entries: 100, per_page: 15, page: pagina.to_i).all
    when 'num_usuarios_mi_cartera'
      Usuario.where("id_carteras IS NOT NULL").count
    when 'titulares'
      mcache_calcula_titulares(modificador)
    when 'otros_posts_forex'
      tag = Tag.find_by_permalink('forex')
      Contenido.select('titulo, contenido_link, contenidos.created_at').etiquetado_con(tag.id).where(tema: Subtipo::POSTS).where('contenidos.blog_id <> ?', Blog::FXPRO).ultimos(5).all
    when /^mas_leido_en_(fondos|depositos|hipotecas|seguros|consumo|economia|empresas|fiscalidad|preferentes)$/
      de_xxx = dato.sub('mas_leido_en_', '')
      Contenido.send("de_#{de_xxx}").select('titulo, contenido_link').con_veces_leido.ultima_semana.order("veces_leidos.leido_semana DESC").limit(10).all
    when /^mas_leido_en_(banca|bolsa)$/
      de_xxx = dato.sub('mas_leido_en_', '')
      Contenido.send("de_#{de_xxx}").select('titulo, contenido_link').con_veces_leido.ultima_semana.order("veces_leidos.leido_semana DESC").limit(10).all
    when /^mas_recomendado_en_(fondos|depositos|hipotecas|seguros|consumo|economia|empresas|fiscalidad|preferentes)$/
      de_xxx = dato.sub('mas_recomendado_en_', '')
      Contenido.send("de_#{de_xxx}").ultima_semana.mas_votados(10).all
    when /^mas_recomendado_en_(banca|bolsa)$/
      de_xxx = dato.sub('mas_recomendado_en_', '')
      Contenido.send("de_#{de_xxx}").ultima_semana.mas_votados(10).all
    when /^mas_leido_en_(etf|hedge-fund|capital-riesgo|planes-de-pensiones|fondos-de-inversion|seguros-coche|seguros-hogar|cfd|forex|sistemas-de-trading|opciones|materias-primas|oro|plata|maiz|petroleo|renta-fija|analisis-fundamental)$/
      etiqueta = dato.sub('mas_leido_en_', '')
      Contenido.mas_leido_con_etiqueta(etiqueta).all
    when /^mas_recomendado_en_(etf|hedge-fund|capital-riesgo|planes-de-pensiones|fondos-de-inversion|seguros-coche|seguros-hogar|cfd|forex|sistemas-de-trading|opciones|materias-primas|oro|plata|maiz|petroleo|renta-fija|analisis-fundamental)$/
      etiqueta = dato.sub('mas_recomendado_en_', '')
      Contenido.mas_recomendado_con_etiqueta(etiqueta).all
    when 'autores_blog'
      Usuario.select('nick, nick_limpio').joins('INNER JOIN blogs_usuarios bu ON bu.usuario_id = usuarios.id').where('bu.blog_id = ?', modificador).order('nick').all
    when 'guia_etiq'
      locale, permalink = modificador.split(',')
      tag = Tag.find_by_permalink(permalink)
      tag ? Contenido.select('titulo, contenido_link, contenidos.created_at').in_locale(locale).etiquetado_con(tag.id).ultimos(10).all : []
    when 'codigo_iso_por_subtipo_id'
      Subtipo.find(modificador).codigo_iso
    when 'dominio_por_subtipo_id'
      mi_cache('dominio_por_pais_id', 'GET', Subtipo.find(modificador).pais_id)
    when 'dominio_por_pais_id'
      HTTP_DOMINIOS[Pais.find(modificador).codigo_iso.to_sym]
    when 'tematicas'
      Tematica.all
    else
      raise "[!] ERROR EN EL USO DE LA CACHE. Se ha intentado acceder con (#{dato}, #{modo}, #{modificador})".inspect
  end
end

def borrar_cache_home_titulares
  pagina = 1
  PAISES.each do |pais|
    mi_cache('home_titulares', 'DELETE', "#{pagina}_#{pais}")
  end
end

def borrar_cache_blogs_destacados
  PAISES.each do |pais|
    mi_cache('blogs_destacados', 'DELETE', pais)
  end
end
