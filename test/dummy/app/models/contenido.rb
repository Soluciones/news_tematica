# coding: UTF-8

class Contenido < ActiveRecord::Base

  attr_accessor :etiqueta_automatica

  belongs_to :usuario
  belongs_to :subtipo
  belongs_to :abuelo, class_name: 'Contenido', foreign_key: 'inicial_id'
  belongs_to :padre, class_name: 'Contenido', foreign_key: 'parent_id'
  belongs_to :blog
  has_one :veces_leido, as: :leido
  has_many :fotos, order: 'orden, id', dependent: :destroy, conditions: 'publicado = true'

  LONG_MAX_TITULO = 120
  TIMEOUT_EDICION = 90.minutes
  TIEMPO_ENTRE_TITULARES = 90.minutes
  SECCIONES = %w(banca cuentas bolsa vivienda seguros economia empresas fiscalidad varios)
  # Para el abatimiento de lo más leído, se multiplica cada n horas (n depende del CRON) por un coef,
  # y sólo se toma en consideración los contenidos creados dentro de una ventana de los últimos n días
  COEF_LOMASLEIDO_DIA = 0.5

  delegate :email, :firma, :posicion_ranking, :posicion_ranking_anual, :puntos, to: :usuario

  scope :publicado, where('contenidos.publicado = true')
  scope :mas_reciente, order('contenidos.created_at DESC')
  scope :join_etiquetas, joins("INNER JOIN taggings t ON t.taggable_id = contenidos.id")  # AND t.taggable_type = 'Contenido'
  scope :etiquetado_con, lambda { |etiq| etiq.class == Fixnum ? join_etiquetas.where('t.tag_id = ?', etiq) : (tag = Tag.find_by_permalink(etiq)) ? join_etiquetas.where('t.tag_id = ?', tag.id) : where('false') }
  scope :ultimos, lambda { |n| mas_reciente.limit(n) }
  scope :ultimos_post_en, lambda { |blog| posts_publicados.where(blog_id: blog).mas_reciente }
  scope :vigente_si_no_admin, lambda { |soy_admin| where('contenidos.created_at < UTC_TIMESTAMP()') if !soy_admin }
  scope :por_fecha, order('contenidos.created_at DESC')
  scope :con_votos, joins('INNER JOIN votos v ON v.contenido_id = contenidos.id')
  scope :campos_titulares, select('contenidos.id, titulo, contenido_link, contenidos.created_at, usr_nick, usr_nick_limpio, descripcion, contenidos.fecha_titulares, keywords, contenidos.subtipo_id, contenidos.publicado, contenidos.blog_id, contenidos.ar, contenidos.cl, contenidos.co, contenidos.es, contenidos.mx, contenidos.pe')
  scope :titulares, campos_titulares.joins('FORCE INDEX (index_contenidos_on_fecha_titulares)').where("contenidos.fecha_titulares IS NOT NULL").order("contenidos.fecha_titulares DESC")
  scope :titulares_en_abierto, titulares.where("contenidos.fecha_titulares < UTC_TIMESTAMP()")
  scope :titulares_completo, joins('FORCE INDEX (index_contenidos_on_fecha_titulares)').where("contenidos.fecha_titulares IS NOT NULL").where("contenidos.fecha_titulares < UTC_TIMESTAMP()").order("contenidos.fecha_titulares DESC")
  scope :link_autor_y_fecha, select('titulo, contenido_link, contenidos.created_at, usr_nick, usr_nick_limpio')
  scope :con_veces_leido, joins("LEFT JOIN veces_leidos ON veces_leidos.leido_id = contenidos.id AND veces_leidos.leido_type = 'Contenido'")
  scope :lista_temas, lambda {|admin| select("contenidos.id, contenidos.titulo, contenidos.texto_completo, contenidos.created_at as tema, contenidos.usr_nick,
              contenidos.usr_nick_limpio, contenidos.contenido_link, #{'vl.contador visitas, ' if admin} contenidos.respuestas_count respuestas,
              contenidos.ultima_respuesta_id, contenidos.fecha_titulares, contenidos.f_caducidad, contenidos.keywords,
              ult_mens.contador, ult_mens.titulo as titulo_ult, ult_mens.created_at as updated_at, ult_mens.texto_completo as respuesta_completa,
              ult_mens.usr_nick as nick_ult, ult_mens.usr_nick_limpio as nick_limpio_ult, ult_mens.contenido_link as link_ult").joins("#{"LEFT JOIN veces_leidos vl ON vl.leido_id = contenidos.id AND vl.leido_type = 'Contenido' " if admin} LEFT JOIN contenidos ult_mens on ult_mens.id = contenidos.ultima_respuesta_id")}
  scope :hace_5_min, lambda { where('created_at > ?', 5.minutes.ago) }
  scope :join_favoritismo_usuario, lambda { |usuario_id| joins("INNER JOIN favoritismos f ON f.usuario_id = #{usuario_id} AND f.favoritable_id = contenidos.id AND f.favoritable_type = 'Contenido'") }

  scope :de_banca, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },banca")})) OR (tema = #{Subtipo::FOROS_BANCA[I18n.locale.to_sym]})") }
  scope :de_bolsa, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },bolsa")})) OR (tema = #{Subtipo::FOROS_BOLSA[I18n.locale.to_sym]})") }
  scope :de_fondos, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },fondos")})) OR (tema = #{Subtipo::FOROFONDOS})") }
  scope :de_depositos, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },depositos")})) OR (tema = #{Subtipo::F_DEPOSITOS})") }
  scope :de_hipotecas, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },vivienda")})) OR (tema = #{Subtipo::F_HIPOTECAS})") }
  scope :de_seguros, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },seguros")})) OR (tema = #{Subtipo::SEGUROS})") }
  scope :de_preferentes, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },preferentes")})) OR (tema = #{Subtipo::PREFERENTES})") }
  scope :de_empresas, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },empresas")})) OR (tema = #{Subtipo::EMPRESAS})") }
  scope :de_consumo, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },consumo")})) OR (tema = #{Subtipo::CONSUMO})") }
  scope :de_economia, lambda{ where(tema: Subtipo::ECONOMIA) }
  scope :de_fiscalidad, lambda{ where(tema: Subtipo::FISCALIDAD) }
  scope :de_sistemas, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },sistemas")})) OR (tema = #{Subtipo::SISTEMAS})") }
  scope :de_opciones, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },opciones")}))") }
  scope :de_futuros, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },futuros")}))") }
  scope :de_cfd, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },juegocfd")}))") }
  scope :de_forex, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },forex")}))") }
  scope :de_materias_primas, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },materias_primas")}))") }
  scope :de_renta_fija, lambda{ where("(tema = (#{Subtipo::POSTS}) AND blog_id IN (#{mi_cache('ids_blogs_por_seccion_publi_SQL', 'GET', "#{ I18n.locale },renta_fija")}))") }

  # La query de posts más recomendados tarda 2 minutos porque el explain indica que hace filesort. Necesitaría índice por votos + created, en vez de solo votos
  # scope :mas_votados, lambda { |n| select('titulo, contenido_link').order('votos_count DESC, contenidos.created_at DESC').limit(n) }
  scope :mas_votados, lambda { |n| select('titulo, contenido_link').order('votos_count DESC').limit(n) }
  scope :mas_leido_con_etiqueta, lambda { |tag| select('titulo, contenido_link').con_veces_leido.ultima_semana.order("veces_leidos.leido_semana DESC").limit(10).etiquetado_con(tag) }
  scope :mas_recomendado_con_etiqueta, lambda { |tag| ultima_semana.mas_votados(10).etiquetado_con(tag) }
  # Para la guía usaremos etiquetado_con porque find_tagged_with no permite meter un select que restrinja los campos a cargar
  scope :titulares_etiquetados_con, lambda { |etiqueta| join_etiquetas.where('t.tag_id = ?', ((tag = Tag.find_by_permalink(etiqueta)) ? tag.id : -1)).where("t.fecha_titulares IS NOT NULL").where("t.fecha_titulares < UTC_TIMESTAMP()").order("t.fecha_titulares DESC") }
  scope :tematica_con, lambda { |campo, locale| titulares_completo.where(campo => true).in_locale(locale).limit(9) }
  scope :tematica_etiquetada_con, lambda { |etiqueta, locale| titulares_etiquetados_con(etiqueta).in_locale(locale).limit(9) }
  scope :campos_msgs_etiquetados, select('contenidos.id, contenidos.titulo, contenidos.contenido_link, contenidos.usr_nick, contenidos.usr_nick_limpio, contenidos.descripcion, contenidos.fecha_titulares, contenidos.keywords, contenidos.publicado, contenidos.subtipo_id, contenidos.created_at').join_etiquetas
  scope :busca_titulo_o_permalink, lambda { |txt| where("titulo LIKE ? OR permalink LIKE ?", "%#{txt}%", "%#{txt}%") }
  scope :in_locale, lambda { |locale| where(locale => true) }

  def factor_corrector_para_nuevos
    (self.created_at > 6.hours.ago) ? 3.0 : (self.created_at > 1.day.ago) ? 2.0 : 1.0
  end

  def dominio
    if !attribute_present?('subtipo_id')
      Antifail.create(tipo: Antifail::RESOLVER_DOMINIO, detalles: "Falta cargar subtipo_id: #{ inspect }")
      HTTP_DOMINIOS[:es]
    elsif subtipo_id == Subtipo::POSTS and attribute_present?('blog_id')
      blog.dominio
    else
      Antifail.create(tipo: Antifail::RESOLVER_DOMINIO, detalles: "falta cargar blog_id: #{ inspect }") if subtipo_id == Subtipo::POSTS
      mi_cache('dominio_por_subtipo_id', 'GET', subtipo_id)
    end
  end
  def contenido_dominio_link
    contenido_link[0..3] == 'http' ? contenido_link : "#{dominio}#{contenido_link}"
  end

  def acepta_contenido(opciones={})
    autor = opciones[:autor] || self.usuario
    if !self.publicado
      subtipo = opciones[:subtipo] || self.subtipo
      valor_tema = opciones[:tema] || self.subtipo_id  # Será subtipo (para inicio hilo) o 0 (para respuestas) en los foros, y subtipo en los demás
      valor_tema = 0 if Subtipo::ARRAY_FOROS.include?(self.subtipo_id) and self.id != self.inicial_id
      self.update_attributes(publicado:  true, tema: valor_tema, usuario_id: autor.id, usr_nick: autor.nick, usr_nick_limpio: autor.nick_limpio, ultima_respuesta_id: self.id)
    end
    nil
  end

  def contador_veces_leido
    veces_leido ? veces_leido.contador : 0
  end

  def contador_veces_leido_dia
    veces_leido ? veces_leido.leido_dia : 0
  end

  def contador_veces_leido_semana
    veces_leido ? veces_leido.leido_semana : 0
  end
end
