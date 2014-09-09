# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130626151549) do

  create_table "abiertos", :force => true do |t|
    t.integer  "newsletter_id"
    t.string   "email"
    t.integer  "usuario_id"
    t.integer  "apuntao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "veces_leido",   :default => 0
  end

  add_index "abiertos", ["newsletter_id", "email"], :name => "index_abiertos_on_newsletter_id_and_email", :unique => true
  add_index "abiertos", ["newsletter_id", "updated_at"], :name => "index_abiertos_on_newsletter_id_and_updated_at"

  create_table "adjuntos", :force => true do |t|
    t.integer  "contenido_id"
    t.integer  "producto_id"
    t.integer  "usuario_id"
    t.boolean  "publicado",            :default => true
    t.integer  "orden"
    t.string   "titulo"
    t.string   "adjunto_file_name"
    t.string   "adjunto_content_type"
    t.integer  "adjunto_file_size"
    t.datetime "adjunto_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adjuntos", ["contenido_id"], :name => "index_adjuntos_on_contenido_id"

  create_table "alertas", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alertas", ["alertable_type", "alertable_id"], :name => "index_alertas_on_alertable_type_and_alertable_id"
  add_index "alertas", ["usuario_id", "alertable_type", "alertable_id"], :name => "ak_alertas_usuario_alerta", :unique => true

  create_table "alumnos", :force => true do |t|
    t.integer  "curso_id"
    t.integer  "usuario_id"
    t.string   "nombre"
    t.string   "apellidos"
    t.string   "cod_postal"
    t.string   "telefono"
    t.string   "email"
    t.string   "observaciones", :limit => 2000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_ip"
  end

  create_table "antifails", :force => true do |t|
    t.string   "tipo"
    t.integer  "usuario_id"
    t.integer  "contenido_id"
    t.integer  "producto_id"
    t.string   "detalles",     :limit => 20000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apuntaos", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apuntaos", ["email"], :name => "index_apuntaos_on_email", :unique => true

  create_table "asistentes", :force => true do |t|
    t.integer  "evento_id",                                                     :null => false
    t.string   "nombre",                                                        :null => false
    t.string   "poblacion"
    t.string   "email",                                                         :null => false
    t.string   "telefono",                                                      :null => false
    t.integer  "numero_de_plazas",                               :default => 1, :null => false
    t.decimal  "pagado",           :precision => 6, :scale => 2
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asistentes", ["evento_id"], :name => "evento_id_2"

  create_table "aux_taggings", :id => false, :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.datetime "created_at"
  end

  add_index "aux_taggings", ["tag_id", "created_at"], :name => "index_aux_taggings_on_tag_id_and_created_at"
  add_index "aux_taggings", ["taggable_id", "tag_id"], :name => "index_aux_taggings_on_taggable_id_and_tag_id", :unique => true

  create_table "avisos", :force => true do |t|
    t.string   "url"
    t.string   "origen"
    t.string   "comentarios"
    t.boolean  "revisado",    :default => false
    t.boolean  "corregido",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backup", :force => true do |t|
    t.string   "trigger"
    t.string   "adapter"
    t.string   "filename"
    t.string   "md5sum"
    t.string   "path"
    t.string   "bucket"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bancos", :force => true do |t|
    t.string   "nombre"
    t.integer  "estado",                                                            :default => 1
    t.string   "promocion_url"
    t.string   "promocion_minitexto", :limit => 1500
    t.string   "permalink"
    t.string   "producto_link"
    t.integer  "usuario_id"
    t.integer  "contenidos_count",                                                  :default => 0
    t.integer  "ultima_valoracion"
    t.decimal  "area1_media",                         :precision => 4, :scale => 2
    t.decimal  "area2_media",                         :precision => 4, :scale => 2
    t.decimal  "area3_media",                         :precision => 4, :scale => 2
    t.decimal  "puntuacion_media",                    :precision => 4, :scale => 2
    t.integer  "favoritismos_count",                                                :default => 0
    t.string   "created_ip"
    t.string   "updated_ip"
    t.string   "updated_usuario"
    t.integer  "rating_fitch_largo"
    t.integer  "rating_fitch_corto"
    t.integer  "rating_sp"
    t.integer  "rating_moodys"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "baneoips", :force => true do |t|
    t.string   "ip"
    t.integer  "usuario_id"
    t.integer  "contenido_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "baneoips", ["ip", "created_at"], :name => "index_baneoips_on_ip_and_created_at"

  create_table "banner_vigentes", :force => true do |t|
    t.string   "seccion",    :null => false
    t.integer  "banner_id",  :null => false
    t.integer  "bloque_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banner_vigentes", ["banner_id"], :name => "banner_id"
  add_index "banner_vigentes", ["bloque_id"], :name => "bloque_id"
  add_index "banner_vigentes", ["seccion"], :name => "index_banner_vigentes_on_seccion"

  create_table "banners", :force => true do |t|
    t.integer  "bloque_id",                           :null => false
    t.integer  "prioridad"
    t.boolean  "activado",        :default => false
    t.datetime "activo_desde",                        :null => false
    t.datetime "activo_hasta",                        :null => false
    t.string   "formato",         :default => "HTML", :null => false
    t.boolean  "home",            :default => false
    t.boolean  "banca",           :default => false
    t.boolean  "bolsa",           :default => false
    t.boolean  "vivienda",        :default => false
    t.boolean  "seguros",         :default => false
    t.boolean  "otros",           :default => false
    t.string   "url_destino"
    t.string   "url_imagen"
    t.string   "texto"
    t.string   "detalles"
    t.integer  "altura"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cartera",         :default => false
    t.boolean  "depositos",       :default => false
    t.boolean  "consumo",         :default => false
    t.boolean  "sistemas",        :default => false
    t.boolean  "desafio",         :default => false
    t.boolean  "opciones",        :default => false
    t.boolean  "juegocfd",        :default => false
    t.boolean  "empresas",        :default => false
    t.boolean  "fondos",          :default => false
    t.boolean  "renta_fija",      :default => false
    t.boolean  "futuros",         :default => false
    t.boolean  "forex",           :default => false
    t.boolean  "materias_primas", :default => false
    t.boolean  "cuentas",         :default => false
    t.boolean  "tarjetas",        :default => false
  end

  add_index "banners", ["bloque_id"], :name => "bloque_id_1"

  create_table "banners_copy", :force => true do |t|
    t.integer  "bloque_id",                          :null => false
    t.integer  "prioridad"
    t.boolean  "activado",        :default => false
    t.datetime "activo_desde",                       :null => false
    t.datetime "activo_hasta",                       :null => false
    t.string   "formato",                            :null => false
    t.boolean  "home",            :default => true
    t.boolean  "banca",           :default => true
    t.boolean  "bolsa",           :default => true
    t.boolean  "vivienda",        :default => true
    t.boolean  "seguros",         :default => true
    t.boolean  "otros",           :default => true
    t.string   "url_destino"
    t.string   "url_imagen"
    t.string   "texto"
    t.string   "detalles"
    t.integer  "altura"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cartera",         :default => true
    t.boolean  "depositos",       :default => true
    t.boolean  "consumo",         :default => true
    t.boolean  "sistemas",        :default => false
    t.boolean  "desafio",         :default => false
    t.boolean  "opciones",        :default => false
    t.boolean  "juegocfd",        :default => false
    t.boolean  "empresas",        :default => true
    t.boolean  "fondos",          :default => true
    t.boolean  "renta_fija",      :default => true
    t.boolean  "futuros",         :default => false
    t.boolean  "forex",           :default => false
    t.boolean  "materias_primas", :default => false
    t.boolean  "cuentas"
    t.boolean  "tarjetas"
  end

  add_index "banners_copy", ["bloque_id"], :name => "bloque_id_2"

  create_table "blogs", :force => true do |t|
    t.string   "url"
    t.string   "titulo"
    t.string   "descripcion"
    t.string   "orden",          :limit => 100
    t.integer  "posts_count"
    t.integer  "ultimo_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_id",     :limit => 25
    t.string   "feedburner_id",  :limit => 100
    t.string   "facebook_id",    :limit => 100
    t.integer  "estado_id",                      :default => 1
    t.string   "publi_superior", :limit => 1000
    t.string   "publi_columna",  :limit => 2000
    t.string   "publi_468",      :limit => 1000
    t.string   "tira_autopromo", :limit => 1000
    t.string   "seccion_banner", :limit => 25
    t.string   "cajon_sastre",   :limit => 8000
    t.string   "footer_post",    :limit => 1200
    t.string   "publi_post",     :limit => 1200
    t.integer  "orden_subnav"
    t.string   "nombre_corto"
    t.string   "columna300x90",  :limit => 1000
    t.string   "baneados",       :limit => 500
    t.integer  "pais_id",                        :default => 1,    :null => false
    t.boolean  "ar",                             :default => true
    t.boolean  "cl",                             :default => true
    t.boolean  "co",                             :default => true
    t.boolean  "es",                             :default => true
    t.boolean  "mx",                             :default => true
    t.boolean  "pe",                             :default => true
  end

  add_index "blogs", ["url"], :name => "index_blogs_on_url", :unique => true

  create_table "blogs_usuarios", :id => false, :force => true do |t|
    t.integer "blog_id",    :null => false
    t.integer "usuario_id", :null => false
  end

  create_table "bloques", :force => true do |t|
    t.string   "tipo",       :null => false
    t.integer  "orden"
    t.string   "nombre",     :null => false
    t.integer  "altura"
    t.integer  "anchura",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bloques", ["tipo", "orden"], :name => "index_bloques_on_tipo_and_orden"

  create_table "busquedas", :force => true do |t|
    t.string   "query"
    t.integer  "usuario_id"
    t.string   "viene_desde"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "busquedas", ["created_at"], :name => "index_busquedas_on_created_at"
  add_index "busquedas", ["query"], :name => "index_busquedas_on_query"

  create_table "candidatos", :force => true do |t|
    t.integer  "premio_id",    :default => 2,                       :null => false
    t.string   "nombre"
    t.string   "url"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "orden"
    t.integer  "puntos_count", :default => 0
    t.string   "seccion",      :default => "Empresas y fiscalidad"
    t.integer  "usuario_id"
    t.string   "nick"
  end

  add_index "candidatos", ["premio_id"], :name => "premio_id"

  create_table "captador_estadisticas", :force => true do |t|
    t.integer  "captador_id"
    t.integer  "n_impresiones",   :default => 0
    t.integer  "n_captaciones",   :default => 0
    t.date     "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dominio_de_alta"
  end

  add_index "captador_estadisticas", ["captador_id", "dominio_de_alta"], :name => "index_captador_estadisticas_on_captador_id_and_dominio_de_alta"

  create_table "chinchetas", :force => true do |t|
    t.integer  "contenido_id"
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clientes", :force => true do |t|
    t.string   "nombre"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comparativas", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "producto_id"
    t.integer  "parent_id"
    t.integer  "subtipo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constantes", :force => true do |t|
    t.integer  "intervalo_portada"
    t.integer  "usuario_nuevo_dias"
    t.integer  "usuario_nuevo_puntos"
    t.integer  "contenidos_timeout_edicion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "coef_lomasleido_dia"
    t.float    "coef_lomasleido_semana"
    t.integer  "ventana_lomasleido_dia"
    t.integer  "ventana_lomasleido_semana"
    t.float    "coef_ranking_12m"
    t.string   "no_etiquetas",                     :limit => 4000
    t.float    "coef_visitas_recientes"
    t.boolean  "fbconnect"
    t.boolean  "csconnect"
    t.boolean  "twconnect"
    t.string   "avisar_vencimiento_destinatarios"
    t.string   "avisar_vencimiento_dias"
    t.datetime "envio_registros_juego"
    t.boolean  "mi_cartera_connect"
    t.boolean  "m1connect"
    t.boolean  "captadorconnect"
  end

  create_table "contenidos", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "inicial_id"
    t.integer  "usuario_id",                                                                            :null => false
    t.integer  "subtipo_id",                                                                            :null => false
    t.boolean  "publicado",                                                          :default => false
    t.integer  "tema",                                                               :default => 0
    t.string   "titulo",                                                                                :null => false
    t.text     "texto_completo"
    t.string   "keywords"
    t.string   "descripcion",         :limit => 400
    t.string   "permalink"
    t.string   "contenido_link"
    t.string   "usr_nick"
    t.string   "usr_nick_limpio"
    t.integer  "veces_leido",                                                        :default => 0
    t.integer  "votos_count",                                                        :default => 0
    t.integer  "images_count",                                                       :default => 0
    t.integer  "respuestas_count",                                                   :default => 0
    t.integer  "ultima_respuesta_id"
    t.integer  "contador",                                                           :default => 0
    t.integer  "producto_id"
    t.string   "lo_mejor"
    t.string   "lo_peor"
    t.integer  "area1"
    t.integer  "area2"
    t.integer  "area3"
    t.integer  "puntuacion"
    t.string   "cliente"
    t.datetime "fecha_cliente"
    t.decimal  "cotizacion",                          :precision => 10, :scale => 2
    t.string   "copyright"
    t.boolean  "banca",                                                              :default => false
    t.boolean  "cuentas",                                                            :default => false
    t.boolean  "bolsa",                                                              :default => false
    t.boolean  "vivienda",                                                           :default => false
    t.boolean  "seguros",                                                            :default => false
    t.boolean  "economia",                                                           :default => false
    t.boolean  "empresas",                                                           :default => false
    t.boolean  "fiscalidad",                                                         :default => false
    t.boolean  "varios",                                                             :default => false
    t.datetime "fecha_titulares"
    t.string   "created_ip"
    t.string   "updated_ip"
    t.string   "updated_usuario"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "leido_dia",                                                          :default => 0
    t.integer  "leido_semana",                                                       :default => 0
    t.string   "votos_link"
    t.datetime "f_caducidad"
    t.integer  "blog_id"
    t.string   "resumen",             :limit => 2000
    t.integer  "fotos_count"
    t.integer  "opinable_id"
    t.string   "opinable_type"
    t.boolean  "ar",                                                                 :default => false
    t.boolean  "cl",                                                                 :default => false
    t.boolean  "co",                                                                 :default => false
    t.boolean  "es",                                                                 :default => true
    t.boolean  "mx",                                                                 :default => false
    t.boolean  "pe",                                                                 :default => false
  end

  add_index "contenidos", ["ar", "created_at"], :name => "index_contenidos_on_ar_and_created_at"
  add_index "contenidos", ["cl", "created_at"], :name => "index_contenidos_on_cl_and_created_at"
  add_index "contenidos", ["co", "created_at"], :name => "index_contenidos_on_co_and_created_at"
  add_index "contenidos", ["created_at"], :name => "index_contenidos_on_created_at"
  add_index "contenidos", ["es", "created_at"], :name => "index_contenidos_on_es_and_created_at"
  add_index "contenidos", ["fecha_titulares"], :name => "index_contenidos_on_fecha_titulares"
  add_index "contenidos", ["inicial_id", "publicado", "created_at"], :name => "index_contenidos_on_inicial_id_and_publicado_and_created_at"
  add_index "contenidos", ["mx", "created_at"], :name => "index_contenidos_on_mx_and_created_at"
  add_index "contenidos", ["opinable_id", "opinable_type"], :name => "index_contenidos_on_opinable_id_and_opinable_type"
  add_index "contenidos", ["parent_id", "publicado", "created_at"], :name => "index_contenidos_on_parent_id_and_publicado_and_created_at"
  add_index "contenidos", ["pe", "created_at"], :name => "index_contenidos_on_pe_and_created_at"
  add_index "contenidos", ["producto_id", "publicado", "created_at"], :name => "index_contenidos_on_producto_id_and_publicado_and_created_at"
  add_index "contenidos", ["subtipo_id", "blog_id", "created_at"], :name => "index_contenidos_on_subtipo_id_and_blog_id_and_created_at"
  add_index "contenidos", ["subtipo_id", "created_at"], :name => "index_contenidos_on_subtipo_id_and_created_at"
  add_index "contenidos", ["subtipo_id", "publicado", "created_at"], :name => "index_contenidos_on_subtipo_id_and_publicado_and_created_at"
  add_index "contenidos", ["tema", "blog_id", "created_at"], :name => "index_contenidos_on_tema_and_blog_id_and_created_at"
  add_index "contenidos", ["tema", "created_at"], :name => "index_contenidos_on_tema_and_created_at"
  add_index "contenidos", ["tema", "respuestas_count"], :name => "index_contenidos_on_tema_and_respuestas_count"
  add_index "contenidos", ["tema", "ultima_respuesta_id"], :name => "index_contenidos_on_tema_and_ultima_respuesta_id"
  add_index "contenidos", ["tema", "veces_leido"], :name => "index_contenidos_on_tema_and_veces_leido"
  add_index "contenidos", ["ultima_respuesta_id"], :name => "ultima_respuesta_id"
  add_index "contenidos", ["usuario_id", "created_at"], :name => "index_contenidos_on_usuario_id_and_created_at"
  add_index "contenidos", ["usuario_id", "inicial_id"], :name => "index_contenidos_on_usuario_id_and_inicial_id"
  add_index "contenidos", ["usuario_id", "publicado", "created_at"], :name => "index_contenidos_on_usuario_publicado_created_at"
  add_index "contenidos", ["usuario_id", "subtipo_id", "publicado", "created_at"], :name => "index_contenidos_on_usuario_subtipo_publicado_created_at"
  add_index "contenidos", ["usuario_id", "tema", "created_at"], :name => "index_contenidos_on_usuario_id_and_tema_and_created_at"
  add_index "contenidos", ["usuario_id", "votos_count", "publicado"], :name => "index_contenidos_on_usuario_votos_count_publicado"
  add_index "contenidos", ["votos_count"], :name => "index_contenidos_on_votos_count"

  create_table "context_publis", :force => true do |t|
    t.string   "frase",                                           :null => false
    t.string   "url",                                             :null => false
    t.string   "seccion_banner", :limit => 500
    t.integer  "contador",                      :default => 0
    t.integer  "clicks",                        :default => 0
    t.boolean  "activo",                        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "correspondencias", :force => true do |t|
    t.string   "desde_permalink",                    :null => false
    t.string   "hacia_name",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hacia_permalink",                    :null => false
    t.integer  "subtipo_id"
    t.boolean  "prioridad",       :default => false
  end

  add_index "correspondencias", ["desde_permalink", "subtipo_id", "hacia_permalink"], :name => "claveunica_corresp_desde_subtipo_hacia", :unique => true
  add_index "correspondencias", ["hacia_permalink"], :name => "index_correspondencias_on_hacia_permalink"

  create_table "cursos", :force => true do |t|
    t.string   "categoria"
    t.string   "permalink"
    t.string   "titulo"
    t.integer  "ponente_id"
    t.datetime "fecha"
    t.string   "resumen",          :limit => 500
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_externa"
    t.string   "password_externa"
    t.integer  "max_alumnos",                     :default => 200
    t.string   "duracion"
    t.string   "modera"
    t.boolean  "notificado",                      :default => false
    t.datetime "fecha_cierre"
  end

  create_table "datos_feeds", :force => true do |t|
    t.string   "nombre_dato",                                                                 :null => false
    t.string   "valor_txt",   :limit => 2000
    t.decimal  "valor_num",                   :precision => 14, :scale => 5, :default => 0.0
    t.integer  "producto_id"
    t.integer  "subtipo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "datos_feeds", ["producto_id"], :name => "index_datos_feeds_on_producto_id"
  add_index "datos_feeds", ["subtipo_id", "nombre_dato", "valor_num"], :name => "index_datos_feed_on_subtipo_id_and_nombre_dato_and_valor_num"
  add_index "datos_feeds", ["subtipo_id", "producto_id", "nombre_dato"], :name => "index_datos_feed_on_subtipo_id_and_producto_id_and_nombre_dato", :unique => true

  create_table "depositos", :force => true do |t|
    t.string   "nombre"
    t.integer  "entidad_id"
    t.integer  "estado"
    t.string   "promocion_url"
    t.string   "promocion_minitexto",         :limit => 1500
    t.string   "permalink"
    t.string   "producto_link"
    t.integer  "usuario_id"
    t.integer  "ultima_valoracion"
    t.integer  "contenidos_count",                                                           :default => 0
    t.integer  "favoritismos_count",                                                         :default => 0
    t.decimal  "area1_media",                                 :precision => 4,  :scale => 2
    t.decimal  "area2_media",                                 :precision => 4,  :scale => 2
    t.decimal  "area3_media",                                 :precision => 4,  :scale => 2
    t.decimal  "puntuacion_media",                            :precision => 4,  :scale => 2
    t.string   "created_ip"
    t.string   "updated_ip"
    t.string   "updated_usuario"
    t.boolean  "con_regalo",                                                                 :default => false
    t.string   "plazo"
    t.decimal  "interes_tae",                                 :precision => 4,  :scale => 2
    t.string   "interes_tae_info",            :limit => 1500
    t.decimal  "interes_nominal",                             :precision => 4,  :scale => 2
    t.string   "interes_nominal_info",        :limit => 1500
    t.string   "liquidacion_intereses"
    t.boolean  "renovacion"
    t.string   "moneda",                      :limit => 20
    t.decimal  "duracion_meses",                              :precision => 5,  :scale => 2
    t.decimal  "importe_max",                                 :precision => 10, :scale => 2
    t.decimal  "importe_min",                                 :precision => 10, :scale => 2
    t.integer  "cuenta_corriente_id"
    t.boolean  "contratacion_online"
    t.boolean  "contratacion_telefono"
    t.boolean  "contratacion_oficina"
    t.boolean  "para_clientes_antiguos"
    t.boolean  "para_clientes_nuevos"
    t.boolean  "para_personas_fisicas"
    t.boolean  "para_personas_juridicas"
    t.boolean  "para_residentes"
    t.boolean  "cancelacion_total"
    t.string   "cancelacion_info",            :limit => 1500
    t.boolean  "disposiciones_parciales"
    t.string   "disposiciones_info",          :limit => 1500
    t.boolean  "comision_cancelacion"
    t.string   "comision_cancelacion_info",   :limit => 1500
    t.boolean  "comision_disposiciones"
    t.string   "comision_disposiciones_info", :limit => 1500
    t.boolean  "comision_fiscalidad"
    t.string   "comision_fiscalidad_info",    :limit => 1500
    t.boolean  "comision_admin_cuenta"
    t.string   "comision_admin_cuenta_info",  :limit => 1500
    t.boolean  "comision_mant_cuenta"
    t.string   "comision_mant_cuenta_info",   :limit => 1500
    t.string   "info_adicional",              :limit => 3000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "depositos", ["entidad_id", "estado"], :name => "index_depositos_on_entidad_id_and_estado"
  add_index "depositos", ["estado"], :name => "index_depositos_on_estado"

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "envio_masivos", :force => true do |t|
    t.integer  "newsletter_id"
    t.integer  "usuarios_id"
    t.integer  "apuntaos_id"
    t.string   "provincias"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "desafio",       :default => false
    t.boolean  "cartera"
  end

  create_table "estadisticas", :force => true do |t|
    t.integer  "usuario_id",                    :null => false
    t.integer  "subtipo_id",                    :null => false
    t.integer  "contador",       :default => 0
    t.integer  "contador_anual", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "estadisticas", ["subtipo_id", "contador"], :name => "index_estadisticas_on_subtipo_id_and_contador"
  add_index "estadisticas", ["subtipo_id", "contador_anual"], :name => "index_estadisticas_on_subtipo_id_and_contador_anual"
  add_index "estadisticas", ["subtipo_id", "usuario_id"], :name => "index_estadisticas_on_subtipo_id_and_usuario_id"
  add_index "estadisticas", ["usuario_id", "subtipo_id"], :name => "index_estadisticas_on_usuario_id_and_subtipo_id"

  create_table "eventos", :force => true do |t|
    t.string   "titulo",                              :null => false
    t.string   "permalink",                           :null => false
    t.datetime "fecha",                               :null => false
    t.string   "resumen",            :limit => 2000
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "texto_aforo"
    t.integer  "banner_id"
    t.string   "texto_confirmacion", :limit => 10000
  end

  create_table "exusuarios", :force => true do |t|
    t.integer  "usuario_id"
    t.string   "nick"
    t.string   "password"
    t.string   "pass_sha"
    t.string   "email"
    t.string   "nombre"
    t.string   "apellidos"
    t.string   "direccion"
    t.string   "poblacion"
    t.string   "cod_postal"
    t.integer  "provincia_id"
    t.integer  "pais_id"
    t.string   "telefono"
    t.string   "web"
    t.text     "descripcion"
    t.string   "firma"
    t.boolean  "juego_bolsa"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "nuevo_juego"
  end

  create_table "favoritismos", :force => true do |t|
    t.integer  "usuario_id",                                    :null => false
    t.string   "tipo",                          :default => "", :null => false
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id",          :limit => 8
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
  end

  add_index "favoritismos", ["favoritable_type", "favoritable_id"], :name => "index_favoritismos_on_favoritable_type_and_favoritable_id"
  add_index "favoritismos", ["usuario_id", "favoritable_type", "favoritable_id"], :name => "ak_favoritismos_usuario_favorito"
  add_index "favoritismos", ["usuario_id", "tipo"], :name => "index_favoritismos_on_usuario_id_and_tipo"

  create_table "fotos", :force => true do |t|
    t.integer  "contenido_id"
    t.integer  "producto_id"
    t.integer  "usuario_id",           :default => 50596
    t.boolean  "publicado",            :default => true
    t.integer  "orden"
    t.string   "titulo"
    t.string   "adjunto_file_name"
    t.string   "adjunto_content_type"
    t.integer  "adjunto_file_size"
    t.datetime "adjunto_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_remote_url"
  end

  add_index "fotos", ["contenido_id"], :name => "index_fotos_on_contenido_id"
  add_index "fotos", ["created_at"], :name => "index_fotos_on_created_at"
  add_index "fotos", ["producto_id"], :name => "index_fotos_on_producto_id"

  create_table "fragmentos", :force => true do |t|
    t.integer  "contenido_id"
    t.text     "texto_renderizado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fragmentos", ["contenido_id"], :name => "index_fragmentos_on_contenido_id", :unique => true

  create_table "frases", :force => true do |t|
    t.string   "texto"
    t.string   "autor"
    t.string   "descripcion",                :limit => 1200
    t.datetime "fecha_ultima_visualizacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "frases", ["fecha_ultima_visualizacion"], :name => "index_frases_on_fecha_ultima_visualizacion"

  create_table "hipotecas", :force => true do |t|
    t.string  "nombre"
    t.integer "entidad_id"
    t.integer "estado",                                                                   :default => 1
    t.string  "promocion_url"
    t.string  "promocion_minitexto",       :limit => 1500
    t.string  "permalink"
    t.string  "producto_link"
    t.integer "usuario_id"
    t.integer "contenidos_count",                                                         :default => 0
    t.integer "ultima_valoracion"
    t.decimal "area1_media",                               :precision => 4,  :scale => 2
    t.decimal "area2_media",                               :precision => 4,  :scale => 2
    t.decimal "area3_media",                               :precision => 4,  :scale => 2
    t.decimal "puntuacion_media",                          :precision => 4,  :scale => 2
    t.integer "favoritismos_count",                                                       :default => 0
    t.string  "created_ip"
    t.string  "updated_ip"
    t.string  "updated_usuario"
    t.boolean "fin_comprar_vivienda"
    t.boolean "fin_cambiar_hipoteca"
    t.boolean "fin_promotor"
    t.boolean "fin_segunda_vivienda"
    t.boolean "fin_local"
    t.boolean "fin_puente"
    t.decimal "interes_tae",                               :precision => 4,  :scale => 2
    t.string  "interes_tae_info",          :limit => 1500
    t.string  "tipo_interes",              :limit => 50
    t.integer "interes_variable_ref"
    t.decimal "interes_variable_dif",                      :precision => 4,  :scale => 2
    t.decimal "interes_fijo",                              :precision => 4,  :scale => 2
    t.decimal "plazo_anos",                                :precision => 10, :scale => 0
    t.decimal "suelo",                                     :precision => 4,  :scale => 2
    t.integer "revision"
    t.decimal "financiacion_max",                          :precision => 5,  :scale => 2
    t.decimal "capital_minimo",                            :precision => 10, :scale => 2
    t.integer "plazo_max_anos"
    t.integer "edad_min"
    t.integer "edad_max"
    t.boolean "contratacion_online"
    t.boolean "contratacion_telefono"
    t.boolean "contratacion_oficina"
    t.integer "comision_estudio_tipo"
    t.decimal "comision_estudio_importe",                  :precision => 10, :scale => 2
    t.string  "comision_estudio_info",     :limit => 1500
    t.integer "comision_apertura_tipo"
    t.decimal "comision_apertura_importe",                 :precision => 10, :scale => 2
    t.string  "comision_apertura_info",    :limit => 1500
    t.decimal "comision_cancelacion",                      :precision => 10, :scale => 2
    t.decimal "comision_amortizacion",                     :precision => 10, :scale => 2
    t.decimal "comision_subrogacion",                      :precision => 10, :scale => 2
    t.boolean "comision_otras"
    t.string  "comision_otras_nombre"
    t.string  "comision_otras_info",       :limit => 3000
    t.boolean "req_nomina"
    t.string  "req_nomina_info",           :limit => 1000
    t.boolean "req_recibos"
    t.string  "req_recibos_info",          :limit => 1000
    t.boolean "req_plan_pensiones"
    t.string  "req_plan_pensiones_info",   :limit => 1000
    t.boolean "req_seguro_hogar"
    t.string  "req_seguro_hogar_info",     :limit => 1000
    t.boolean "req_seguro_vida"
    t.string  "req_seguro_vida_info",      :limit => 1000
    t.boolean "req_cuenta"
    t.string  "req_cuenta_info",           :limit => 1000
    t.boolean "req_tarjeta"
    t.string  "req_tarjeta_info",          :limit => 1000
    t.boolean "req_otros"
    t.string  "req_otros_nombre"
    t.string  "req_otros_info",            :limit => 1000
    t.string  "carencia_inicial",          :limit => 1000
    t.integer "cuotas_aplazables"
    t.text    "info_adicional"
  end

  add_index "hipotecas", ["entidad_id", "estado"], :name => "index_hipotecas_on_entidad_id_and_estado"
  add_index "hipotecas", ["estado"], :name => "index_hipotecas_on_estado"

  create_table "images", :force => true do |t|
    t.string   "title"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "usuario_id"
    t.integer  "producto_id"
    t.integer  "contenido_id"
    t.integer  "orden"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "publicado",    :default => true
  end

  add_index "images", ["contenido_id", "orden", "id"], :name => "index_images_on_contenido_id_and_orden_and_id"
  add_index "images", ["parent_id", "thumbnail"], :name => "index_images_on_parent_id_and_thumbnail"
  add_index "images", ["producto_id", "contenido_id", "orden", "id"], :name => "index_images_on_producto_id_and_contenido_id_and_orden_and_id"
  add_index "images", ["usuario_id"], :name => "usuario_id"

  create_table "importacion_blogger_comentarios", :force => true do |t|
    t.integer  "importacion_blogger_post_id"
    t.string   "autor"
    t.text     "contenido"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_id"
  end

  create_table "importacion_blogger_posts", :force => true do |t|
    t.integer  "importacion_blogger_id"
    t.string   "titulo"
    t.string   "autor"
    t.text     "contenido"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_id"
    t.string   "contenido_link"
  end

  create_table "importacion_bloggers", :force => true do |t|
    t.string   "titulo"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interesados", :force => true do |t|
    t.string   "nombre",      :limit => 40
    t.string   "apellido",    :limit => 40
    t.string   "apellido2",   :limit => 40
    t.string   "telefono",    :limit => 30
    t.string   "email",       :limit => 60
    t.text     "comentarios"
    t.string   "promocion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", :force => true do |t|
    t.integer  "promocion_id"
    t.string   "nombre"
    t.string   "apellido1"
    t.string   "apellido2"
    t.string   "telefono"
    t.string   "telefono_2"
    t.string   "email"
    t.string   "comentarios"
    t.string   "dni"
    t.integer  "provincia_id"
    t.string   "horario_contacto"
    t.string   "situacion_laboral"
    t.string   "edad"
    t.string   "finalidad"
    t.string   "valor_tasacion"
    t.string   "precio_compra"
    t.string   "importe_solicitado"
    t.string   "ingresos_mensuales"
    t.string   "otras_cuotas"
    t.string   "plazo"
    t.string   "fecha_firma"
    t.decimal  "loan_to_value",                       :precision => 5, :scale => 2
    t.decimal  "loan_to_price",                       :precision => 5, :scale => 2
    t.decimal  "ingresos_menos_cuotas",               :precision => 8, :scale => 2
    t.decimal  "pct_endeudamiento",                   :precision => 5, :scale => 2
    t.integer  "edad_finalizacion"
    t.decimal  "cuota_viabilidad",                    :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enviado"
    t.string   "direccion"
    t.string   "poblacion"
    t.string   "documento"
    t.string   "horario_contacto_2"
    t.string   "cod_postal",             :limit => 5
    t.integer  "usuario_id"
    t.integer  "version_html_promocion",                                            :default => 1
  end

  add_index "leads", ["promocion_id", "created_at"], :name => "index_leads_on_promocion_id_and_created_at"
  add_index "leads", ["usuario_id"], :name => "index_leads_on_usuario_id"

  create_table "lecturas", :force => true do |t|
    t.integer  "seccion"
    t.integer  "subtipo_id"
    t.integer  "destino_id"
    t.date     "dia"
    t.integer  "veces_leido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lecturas", ["dia", "seccion", "destino_id"], :name => "index_lecturas_on_dia_and_seccion_and_destino_id"
  add_index "lecturas", ["dia", "subtipo_id", "destino_id"], :name => "index_lecturas_on_dia_and_subtipo_id_and_destino_id"
  add_index "lecturas", ["seccion", "destino_id", "dia"], :name => "index_lecturas_on_seccion_and_destino_id_and_dia", :unique => true

  create_table "likerts", :force => true do |t|
    t.string   "producto"
    t.string   "elemento_a_valorar"
    t.string   "rotulo"
    t.string   "rotulo_corto",       :limit => 25
    t.integer  "nota"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likerts", ["producto", "elemento_a_valorar", "nota"], :name => "index_likerts_on_producto_and_elemento_a_valorar_and_nota"

  create_table "log_envio_masivos", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "apuntao_id"
    t.string   "email",         :null => false
    t.integer  "newsletter_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logproductos", :force => true do |t|
    t.integer  "producto_id"
    t.string   "producto_nombre"
    t.string   "tipo"
    t.string   "accion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "news_tematica_news_tematicas", :force => true do |t|
    t.integer  "tematica_id"
    t.string   "titulo"
    t.text     "html"
    t.datetime "fecha_desde"
    t.datetime "fecha_hasta"
    t.datetime "fecha_envio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_1_url_imagen"
    t.string   "banner_1_url_destino"
    t.string   "banner_1_texto_alt"
    t.string   "banner_2_url_imagen"
    t.string   "banner_2_url_destino"
    t.string   "banner_2_texto_alt"
    t.boolean  "enviada",              :default => false
  end

  create_table "newsletter_en_esperas", :force => true do |t|
    t.string   "nombre_newsletter"
    t.datetime "momento_envio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "asunto"
    t.text     "cuerpo"
    t.boolean  "enviado",          :default => false
    t.integer  "tipo"
    t.integer  "ndestinatarios",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "abiertos_count",   :default => 0
    t.integer  "segundo_envio_id"
    t.text     "cuerpo_b"
    t.integer  "abiertos_a",       :default => 0
    t.integer  "abiertos_b",       :default => 0
    t.string   "asunto_b"
  end

  create_table "pagestaticas", :force => true do |t|
    t.string   "bloque",      :limit => 40
    t.string   "permalink",   :limit => 60
    t.string   "alias",       :limit => 40
    t.string   "titulo"
    t.string   "keywords",    :limit => 400
    t.string   "descripcion", :limit => 400
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nueva_url"
  end

  add_index "pagestaticas", ["bloque", "permalink"], :name => "URL_UNICA", :unique => true

  create_table "paises", :force => true do |t|
    t.string   "nombre",                         :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "codigo_iso", :default => "otro"
  end

  add_index "paises", ["position"], :name => "index_paises_on_position"

  create_table "participantes", :force => true do |t|
    t.integer  "posicion"
    t.string   "nick"
    t.integer  "dia"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "juego"
    t.decimal  "importe",      :precision => 10, :scale => 2
    t.decimal  "rentabilidad", :precision => 8,  :scale => 4
    t.date     "fecha"
  end

  create_table "permisos", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "subtipo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permisos", ["subtipo_id"], :name => "subtipo_id_3"
  add_index "permisos", ["usuario_id"], :name => "usuario_id_1"

  create_table "ponentes", :force => true do |t|
    t.string   "nombre"
    t.string   "permalink"
    t.string   "cargo"
    t.string   "biografia",           :limit => 20000
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postalcodes", :force => true do |t|
    t.string   "codigo",     :null => false
    t.string   "zona",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "postalcodes", ["codigo"], :name => "ix_postalcodes_codigo"

  create_table "postalcodes_kk", :force => true do |t|
    t.string   "codigo",     :null => false
    t.string   "zona",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "precios", :force => true do |t|
    t.integer  "evento_id",                                   :null => false
    t.decimal  "importe",       :precision => 6, :scale => 2, :null => false
    t.datetime "fecha_validez",                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "precios", ["evento_id"], :name => "evento_id_1"

  create_table "premios", :force => true do |t|
    t.string   "titulo",                                                                                                                              :null => false
    t.string   "permalink",                                                                                                                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "descripcion",        :limit => 4000
    t.datetime "ultimo_dia"
    t.integer  "minimo_votos_otros",                 :default => 10
    t.string   "secciones",                          :default => "Economía, consumo y fiscalidad;Seguros;Bolsa;Banca;Fondos de inversión;Renta fija"
  end

  create_table "productos", :force => true do |t|
    t.string   "type"
    t.integer  "usuario_id",                                                                                   :null => false
    t.integer  "subtipo_id",                                                                                   :null => false
    t.boolean  "publicado",                                                                 :default => true
    t.string   "nombre",                                                                                       :null => false
    t.string   "keywords"
    t.string   "descripcion"
    t.string   "permalink"
    t.string   "producto_link"
    t.integer  "ultima_valoracion"
    t.string   "web"
    t.string   "propietario"
    t.string   "ticker"
    t.string   "isin"
    t.string   "mercado"
    t.integer  "veces_visto",                                                               :default => 0
    t.decimal  "area1_media",                                :precision => 4,  :scale => 2
    t.decimal  "area2_media",                                :precision => 4,  :scale => 2
    t.decimal  "area3_media",                                :precision => 4,  :scale => 2
    t.decimal  "puntuacion_media",                           :precision => 4,  :scale => 2
    t.integer  "favoritismos_count",                                                        :default => 0
    t.integer  "images_count",                                                              :default => 0
    t.integer  "contenidos_count",                                                          :default => 0
    t.integer  "tipo_producto_id"
    t.boolean  "domiciliacion"
    t.string   "pago_intereses"
    t.string   "gestora"
    t.string   "comision_gestion"
    t.string   "comision_deposito"
    t.string   "comision_suscripcion"
    t.string   "comision_reembolso"
    t.string   "created_ip"
    t.string   "updated_ip"
    t.string   "updated_usuario"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plazo"
    t.decimal  "importe_minimo",                             :precision => 10, :scale => 2
    t.decimal  "importe_maximo",                             :precision => 10, :scale => 2
    t.decimal  "tae",                                        :precision => 4,  :scale => 2
    t.string   "entidad_nombre"
    t.string   "otras_condiciones",          :limit => 1200
    t.string   "prestamo_o_credito"
    t.string   "indice_referencia"
    t.decimal  "diferencial",                                :precision => 4,  :scale => 2
    t.integer  "max_anyos"
    t.integer  "pct_max_financiacion"
    t.boolean  "nomina",                                                                    :default => false
    t.boolean  "seguro_hogar",                                                              :default => false
    t.boolean  "seguro_vida",                                                               :default => false
    t.boolean  "tarjetas",                                                                  :default => false
    t.boolean  "otros",                                                                     :default => false
    t.integer  "entidad_id"
    t.string   "entidad_url"
    t.string   "nombre_feed"
    t.string   "url_promo"
    t.decimal  "plazo_meses",                                :precision => 5,  :scale => 2
    t.integer  "estado",                                                                    :default => 1
    t.decimal  "interes_nominal",                            :precision => 4,  :scale => 2
    t.boolean  "comision_transferencia",                                                    :default => false
    t.boolean  "comision_mantenimiento",                                                    :default => false
    t.string   "mini_html_promo"
    t.string   "fitch_largo",                :limit => 4
    t.string   "fitch_corto",                :limit => 4
    t.string   "moody",                      :limit => 4
    t.string   "sp",                         :limit => 4
    t.string   "tae_info"
    t.decimal  "tae_final",                                  :precision => 5,  :scale => 2
    t.string   "tae_final_info"
    t.decimal  "franquicia",                                 :precision => 8,  :scale => 2
    t.string   "franquicia_info"
    t.string   "tarjeta_credito",            :limit => 25
    t.string   "tarjeta_debito",             :limit => 25
    t.string   "talonario",                  :limit => 25
    t.decimal  "apertura_minima",                            :precision => 8,  :scale => 2
    t.integer  "edad_minima"
    t.string   "nomina_info"
    t.string   "domiciliacion_info"
    t.boolean  "cuenta_asociada"
    t.string   "contrata_online",            :limit => 5
    t.string   "contrata_tel",               :limit => 5
    t.string   "contrata_oficina",           :limit => 5
    t.string   "dirigido_a",                 :limit => 5
    t.string   "dirigido_a_info"
    t.string   "permanencia_minima",         :limit => 99
    t.string   "regalo",                     :limit => 99
    t.string   "otros_beneficios"
    t.string   "bonificacion_recibos",       :limit => 99
    t.string   "bonificacion_tarjetas"
    t.string   "otras_bonificaciones"
    t.string   "com_mantenimiento",          :limit => 99
    t.string   "com_transf_nacional",        :limit => 99
    t.string   "com_transf_nacional_info"
    t.string   "com_otras_transf"
    t.string   "com_descubierto"
    t.string   "descubiertos_cajeros"
    t.string   "descubiertos_tarjetas"
    t.string   "descubiertos_tarjetas_info"
    t.integer  "fotos_count"
  end

  add_index "productos", ["publicado", "ultima_valoracion"], :name => "index_productos_on_publicado_and_ultima_valoracion"
  add_index "productos", ["subtipo_id", "publicado", "created_at"], :name => "index_productos_on_subtipo_id_and_publicado_and_created_at"
  add_index "productos", ["tipo_producto_id"], :name => "tipo_producto_id_2"
  add_index "productos", ["type", "publicado", "created_at"], :name => "index_productos_on_type_and_publicado_and_created_at"
  add_index "productos", ["ultima_valoracion", "publicado"], :name => "index_productos_on_ultima_valoracion_and_publicado"
  add_index "productos", ["usuario_id"], :name => "usuario_id_2"

  create_table "promo_completas", :force => true do |t|
    t.string   "codigo_promo"
    t.integer  "usuario_id"
    t.string   "user_agent"
    t.string   "referer_url"
    t.string   "ultima_pagina_en_esta_web"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promociones", :force => true do |t|
    t.integer  "tipo_id"
    t.integer  "cliente_id"
    t.string   "titulo"
    t.string   "bloque"
    t.string   "permalink"
    t.text     "html"
    t.string   "archivo_css"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mini_html",    :limit => 4000
    t.datetime "fecha_limite"
    t.integer  "orden",                        :default => 0
    t.string   "medio_html",   :limit => 1000
    t.integer  "entidad_id"
    t.datetime "fecha_inicio"
    t.string   "url_promo"
    t.string   "lugar"
    t.datetime "fecha_curso"
    t.string   "precio"
    t.text     "html2"
    t.text     "html3"
    t.integer  "ultimo_html",                  :default => 1
    t.string   "copy_boton",                   :default => "Enviar"
    t.string   "color_boton"
    t.string   "tipo_boton"
  end

  create_table "provincias", :force => true do |t|
    t.integer  "pais_id",    :null => false
    t.string   "nombre",     :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provincias", ["pais_id", "position"], :name => "index_provincias_on_pais_id_and_position"
  add_index "provincias", ["position"], :name => "index_provincias_on_position"

  create_table "puntos", :force => true do |t|
    t.integer  "candidato_id",               :null => false
    t.integer  "usuario_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_ip",   :limit => 39
  end

  add_index "puntos", ["candidato_id"], :name => "candidato_id"
  add_index "puntos", ["usuario_id"], :name => "usuario_id_3"

  create_table "rbdis", :force => true do |t|
    t.datetime "dia"
    t.integer  "mens_bolsa"
    t.integer  "mens_depositos"
    t.decimal  "ratio_mens",       :precision => 6, :scale => 4
    t.integer  "usu_bolsa"
    t.integer  "usu_depositos"
    t.decimal  "ratio_usu",        :precision => 6, :scale => 4
    t.decimal  "ratio_ratio",      :precision => 6, :scale => 4
    t.decimal  "media_semanal",    :precision => 6, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "dato_logaritmico", :precision => 5, :scale => 2
  end

  add_index "rbdis", ["dia"], :name => "dia", :unique => true

  create_table "redirections", :force => true do |t|
    t.string   "url"
    t.string   "nota"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "news_tematica_id"
  end

  add_index "redirections", ["news_tematica_id", "url"], :name => "index_redirections_on_news_tematica_id_and_url"

  create_table "relacionados", :force => true do |t|
    t.integer  "contenido_id"
    t.string   "titulo",       :limit => 400
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blog_id"
    t.integer  "orden"
  end

  add_index "relacionados", ["contenido_id"], :name => "index_relacionados_on_contenido_id"

  create_table "revisados", :force => true do |t|
    t.integer  "contenido_id"
    t.string   "tipo"
    t.string   "estado"
    t.string   "revisado_por"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "revisados", ["created_at"], :name => "index_revisados_on_created_at"

  create_table "sessions", :force => true do |t|
    t.string   "session_id",                   :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cs_ping"
    t.integer  "cs_get_count",  :default => 0
    t.integer  "cs_post_count", :default => 0
    t.string   "cs_ip"
  end

  add_index "sessions", ["cs_ip"], :name => "index_sessions_on_cs_ip"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simuladores", :force => true do |t|
    t.integer  "tipo"
    t.integer  "usuario_id"
    t.string   "nombre"
    t.decimal  "dinero_a_invertir",     :precision => 11, :scale => 2
    t.integer  "meses"
    t.decimal  "tae",                   :precision => 6,  :scale => 4
    t.decimal  "intereses_brutos",      :precision => 11, :scale => 2
    t.decimal  "intereses_netos",       :precision => 11, :scale => 2
    t.decimal  "importe_a_vencimiento", :precision => 11, :scale => 2
    t.string   "created_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "anyos"
    t.decimal  "cuota_mensual",         :precision => 8,  :scale => 2
    t.decimal  "euribor",               :precision => 6,  :scale => 4
    t.decimal  "diferencial",           :precision => 4,  :scale => 2
    t.decimal  "interes_actual",        :precision => 6,  :scale => 4
    t.decimal  "subrogacion",           :precision => 4,  :scale => 2
    t.decimal  "comision_subrogacion",  :precision => 11, :scale => 2
    t.decimal  "ahorro_anual",          :precision => 11, :scale => 2
    t.string   "plazo"
    t.decimal  "ahorro_total",          :precision => 11, :scale => 2
    t.decimal  "ahorro_primer_anyo",    :precision => 10, :scale => 2
  end

  add_index "simuladores", ["usuario_id"], :name => "usuario_id_4"

  create_table "subtipos", :force => true do |t|
    t.string   "nombre",                                        :null => false
    t.string   "nombre_corto",                                  :null => false
    t.string   "nombre_completo",                               :null => false
    t.string   "seccion_banner"
    t.integer  "position"
    t.string   "url"
    t.string   "permalink",                                     :null => false
    t.string   "keywords"
    t.string   "descripcion"
    t.integer  "contenidos_count",             :default => 0
    t.integer  "productos_temas_count",        :default => 0
    t.integer  "puntos_contenido_corto",       :default => 1
    t.integer  "puntos_contenido_largo",       :default => 10
    t.integer  "puntos_contenido_muy_largo",   :default => 10
    t.integer  "long_min_contenido_largo",     :default => 200
    t.integer  "long_min_contenido_muy_largo", :default => 300
    t.integer  "ultimo_contenido"
    t.integer  "ultimo_producto_tema"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre_mediocorto"
    t.integer  "usr_gestor_permisos"
    t.integer  "pais_id",                      :default => 1
  end

  create_table "suscripciones", :force => true do |t|
    t.integer  "tematica_id"
    t.integer  "suscriptor_id"
    t.string   "suscriptor_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre_apellidos"
    t.string   "email"
    t.string   "dominio_de_alta",  :default => "es"
    t.string   "cod_postal"
    t.integer  "provincia_id"
    t.boolean  "activo",           :default => true
  end

  add_index "suscripciones", ["suscriptor_id"], :name => "index_suscripciones_on_suscriptor_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",                             :null => false
    t.integer  "taggable_id",                        :null => false
    t.string   "taggable_type"
    t.datetime "created_at"
    t.integer  "blog_id"
    t.integer  "tema",                :default => 0
    t.integer  "ultima_respuesta_id"
    t.datetime "fecha_titulares"
  end

  add_index "taggings", ["blog_id", "tag_id"], :name => "index_taggings_on_blog_id_and_tag_id"
  add_index "taggings", ["tag_id", "created_at"], :name => "index_taggings_on_tag_id_and_created_at"
  add_index "taggings", ["tag_id", "fecha_titulares"], :name => "index_taggings_on_tag_id_and_fecha_titulares"
  add_index "taggings", ["tag_id", "tema"], :name => "index_taggings_on_tag_id_and_tema"
  add_index "taggings", ["tag_id", "ultima_respuesta_id"], :name => "index_taggings_on_tag_id_and_ultima_respuesta_id"
  add_index "taggings", ["taggable_id", "taggable_type", "tag_id"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_tag_id", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string   "name",                                   :default => "",    :null => false
    t.integer  "taggings_count",                         :default => 0
    t.datetime "ultimo_tagging"
    t.string   "permalink",                              :default => "",    :null => false
    t.integer  "subtipo_id"
    t.integer  "prioridad"
    t.string   "seccion_banner"
    t.integer  "tipo_producto_id"
    t.boolean  "dudosa"
    t.boolean  "revisada"
    t.string   "publi_superior",         :limit => 1000
    t.string   "publi_columna",          :limit => 2000
    t.string   "publi_468",              :limit => 1000
    t.string   "tira_autopromo",         :limit => 1000
    t.integer  "visitas",                                :default => 0
    t.integer  "visitas_recientes",                      :default => 0
    t.string   "publi_columna_inferior", :limit => 1200
    t.boolean  "ar",                                     :default => false
    t.boolean  "cl",                                     :default => false
    t.boolean  "co",                                     :default => false
    t.boolean  "es",                                     :default => true
    t.boolean  "mx",                                     :default => false
    t.boolean  "pe",                                     :default => false
    t.string   "categoria"
    t.string   "carpeta"
    t.boolean  "internacional",                          :default => false
  end

  add_index "tags", ["ar", "categoria", "carpeta"], :name => "index_tags_on_ar_and_categoria_and_carpeta"
  add_index "tags", ["cl", "categoria", "carpeta"], :name => "index_tags_on_cl_and_categoria_and_carpeta"
  add_index "tags", ["co", "categoria", "carpeta"], :name => "index_tags_on_co_and_categoria_and_carpeta"
  add_index "tags", ["es", "categoria", "carpeta"], :name => "index_tags_on_es_and_categoria_and_carpeta"
  add_index "tags", ["mx", "categoria", "carpeta"], :name => "index_tags_on_mx_and_categoria_and_carpeta"
  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true
  add_index "tags", ["pe", "categoria", "carpeta"], :name => "index_tags_on_pe_and_categoria_and_carpeta"
  add_index "tags", ["permalink"], :name => "index_tags_on_permalink", :unique => true
  add_index "tags", ["subtipo_id"], :name => "subtipo_id_1"
  add_index "tags", ["taggings_count"], :name => "index_tags_on_taggings_count"
  add_index "tags", ["tipo_producto_id"], :name => "tipo_producto_id_1"
  add_index "tags", ["ultimo_tagging"], :name => "index_tags_on_ultimo_tagging"

  create_table "tematicas", :force => true do |t|
    t.string   "nombre"
    t.string   "seccion_publi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "texto"
    t.integer  "tag_id"
    t.integer  "subtipo_id"
    t.string   "seccion_titulares"
    t.string   "scope_mas_leido"
  end

  create_table "tipo_productos", :force => true do |t|
    t.integer  "subtipo_id",                                      :null => false
    t.string   "grupo"
    t.string   "nombre"
    t.integer  "position",                       :default => 999
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "info_adicional", :limit => 1000
    t.string   "seccion_publi"
  end

  add_index "tipo_productos", ["subtipo_id"], :name => "subtipo_id_2"

  create_table "titulares", :force => true do |t|
    t.integer  "contenido_id"
    t.integer  "tema_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "titulares", ["created_at"], :name => "index_titulares_on_created_at"
  add_index "titulares", ["tema_id", "created_at"], :name => "index_titulares_on_tema_id_and_created_at"

  create_table "tmp", :id => false, :force => true do |t|
    t.integer "dato_int"
  end

  add_index "tmp", ["dato_int"], :name => "index_tmp_on_dato_int"

  create_table "tmp2", :force => true do |t|
    t.integer "dato1"
    t.integer "dato2"
    t.decimal "dato_dec",                  :precision => 6, :scale => 2
    t.string  "dato_txt"
    t.string  "dato_txt2"
    t.string  "txt",       :limit => 5000
  end

  add_index "tmp2", ["dato1"], :name => "index_tmp2_on_dato1"

  create_table "ultimos", :force => true do |t|
    t.string   "tipo_publicacion",                      :null => false
    t.integer  "subtipo_id"
    t.integer  "usuario_id",                            :null => false
    t.string   "usr_nick",                              :null => false
    t.string   "usr_nick_limpio",                       :null => false
    t.integer  "contenido_id"
    t.string   "contenido_link"
    t.string   "titulo"
    t.string   "resumen",                :limit => 600
    t.string   "seccion_html"
    t.string   "responde_a_nick"
    t.string   "responde_a_nick_limpio"
    t.integer  "producto_id"
    t.string   "producto_link"
    t.string   "producto_nombre"
    t.string   "img_url"
    t.integer  "id_ultima"
    t.integer  "id_penultima"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ultimos", ["contenido_id"], :name => "ix_ultimos_on_contenido_id"
  add_index "ultimos", ["created_at"], :name => "ix_ultimos_on_created_at"
  add_index "ultimos", ["id_penultima"], :name => "ix_ultimos_on_id_penultima"
  add_index "ultimos", ["id_ultima"], :name => "ix_ultimos_on_id_ultima"
  add_index "ultimos", ["usuario_id", "created_at"], :name => "ix_ultimos_on_usuario_id_and_created_at"
  add_index "ultimos", ["usuario_id", "tipo_publicacion", "created_at"], :name => "ix_ultimos_on_usuario_id_and_tipo_publicacion_and_created_at"

  create_table "usuarios", :force => true do |t|
    t.integer  "estado_id",                                  :default => 0,      :null => false
    t.string   "nick",                                                           :null => false
    t.string   "nick_limpio",                                                    :null => false
    t.string   "pass_sha"
    t.string   "email",                                                          :null => false
    t.string   "nombre",                                                         :null => false
    t.string   "apellidos",                                                      :null => false
    t.string   "direccion"
    t.string   "poblacion"
    t.string   "cod_postal"
    t.integer  "provincia_id",                               :default => 53
    t.integer  "pais_id",                                                        :null => false
    t.string   "telefono"
    t.string   "web"
    t.text     "descripcion"
    t.string   "firma"
    t.boolean  "foro_alertas",                               :default => true
    t.boolean  "producto_alertas",                           :default => true
    t.datetime "ultimo_acceso"
    t.integer  "perfil",                                     :default => 1
    t.boolean  "juego_bolsa"
    t.integer  "posicion_ranking",                           :default => 999999
    t.integer  "posicion_ranking_anual",                     :default => 999999
    t.integer  "puntos",                                     :default => 0
    t.integer  "puntos_anual",                               :default => 0
    t.string   "token_autorizacion"
    t.datetime "token_fecha"
    t.integer  "num_fans",                                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "correo_defectuoso",                          :default => false
    t.datetime "usuario_del_dia"
    t.datetime "fecha_juego"
    t.integer  "votos_count",                                :default => 0
    t.integer  "veces_votado",                               :default => 0
    t.boolean  "avisar_fan",                                 :default => true
    t.boolean  "avisar_msg_recomendado",                     :default => true
    t.boolean  "avisar_msg_guardado",                        :default => true
    t.datetime "fecha_ping"
    t.integer  "id_carteras"
    t.datetime "ultimo_login_carteras"
    t.datetime "alta_carteras"
    t.string   "alta_adwords"
    t.string   "created_ip",                 :limit => 39
    t.string   "ultimo_acceso_ip",           :limit => 39
    t.integer  "envios_count",                               :default => 0
    t.string   "anotaciones",                :limit => 4000
    t.integer  "usuarios_count",                             :default => 0
    t.integer  "contenidos_guardados_count",                 :default => 0
    t.integer  "productos_guardados_count",                  :default => 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "origen"
    t.boolean  "nuevo_juego"
    t.string   "nick_impok"
    t.boolean  "juego_bolsa_activado"
    t.integer  "perfil_forex"
    t.string   "dominio_de_alta"
    t.string   "password"
    t.string   "perfil_inversor",            :limit => 15
  end

  add_index "usuarios", ["alta_carteras"], :name => "index_usuarios_on_alta_carteras"
  add_index "usuarios", ["created_at"], :name => "index_usuarios_on_created_at"
  add_index "usuarios", ["email"], :name => "index_usuarios_on_email", :unique => true
  add_index "usuarios", ["nick"], :name => "index_usuarios_on_nick", :unique => true
  add_index "usuarios", ["nick_limpio"], :name => "index_usuarios_on_nick_limpio", :unique => true
  add_index "usuarios", ["pais_id"], :name => "pais_id"
  add_index "usuarios", ["posicion_ranking"], :name => "index_usuarios_on_posicion_ranking"
  add_index "usuarios", ["posicion_ranking_anual"], :name => "index_usuarios_on_posicion_ranking_anual"
  add_index "usuarios", ["provincia_id"], :name => "provincia_id"
  add_index "usuarios", ["token_autorizacion"], :name => "index_usuarios_on_token_autorizacion"
  add_index "usuarios", ["usuario_del_dia", "posicion_ranking"], :name => "index_usuarios_on_usuario_del_dia_and_posicion_ranking"
  add_index "usuarios", ["veces_votado"], :name => "index_usuarios_on_veces_votado"

  create_table "veces_leidos", :force => true do |t|
    t.string   "leido_type"
    t.integer  "leido_id"
    t.integer  "grupo"
    t.integer  "contador",     :default => 0
    t.integer  "leido_dia",    :default => 0
    t.integer  "leido_semana", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "veces_leidos", ["grupo", "contador"], :name => "index_veces_leidos_on_grupo_and_contador"
  add_index "veces_leidos", ["leido_id", "leido_type"], :name => "index_veces_leidos_on_leido_id_and_leido_type", :unique => true

  create_table "visitas", :force => true do |t|
    t.integer  "redirection_id", :null => false
    t.integer  "usuario_id"
    t.string   "referer_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_agent"
    t.string   "robot"
    t.string   "created_ip"
  end

  add_index "visitas", ["created_at"], :name => "index_visitas_on_created_at"
  add_index "visitas", ["redirection_id"], :name => "index_visitas_on_redirection_id"
  add_index "visitas", ["redirection_id"], :name => "redirection_id"
  add_index "visitas", ["usuario_id"], :name => "usuario_id_5"

  create_table "visitas_tmp", :id => false, :force => true do |t|
    t.integer  "id"
    t.string   "user_agent"
    t.string   "permalink"
    t.datetime "created_at"
  end

  create_table "votos", :force => true do |t|
    t.integer  "usuario_id",                :null => false
    t.integer  "contenido_id",              :null => false
    t.integer  "autor_id",                  :null => false
    t.string   "created_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id",      :limit => 8
  end

  add_index "votos", ["autor_id", "created_at"], :name => "index_votos_on_autor_id_and_created_at"
  add_index "votos", ["contenido_id", "usuario_id"], :name => "index_votos_on_contenido_id_and_usuario_id", :unique => true
  add_index "votos", ["created_at"], :name => "index_votos_on_created_at"
  add_index "votos", ["post_id"], :name => "index_votos_on_post_id"
  add_index "votos", ["usuario_id", "created_at"], :name => "index_votos_on_usuario_id_and_created_at"

end
