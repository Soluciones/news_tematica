# coding: UTF-8

require 'digest/sha1'     # Algoritmo de hashing seguro.

class Usuario < ActiveRecord::Base

  MAX_PRIVADOS_USR_NUEVO = 5
  # Valores de Usuario.nivel 0=Sin activar, 1=Usuario, 2=Moderador/Editor, 3=Administrador, 4=Gestor de usuarios, 5=Superadmin/Programador, -2=Baneado, -1=Desactivado.
  ESTADO_BANEADO = -2
  ESTADO_DESHABILITADO = -1
  ESTADO_SIN_ACTIVAR = 0
  ESTADO_NORMAL = 1
  ESTADO_MODERADOR = 2  # Tendrá permisos para editar sus contenidos por tiempo ilimitado, y podrá pasar mensajes a moderación. No puede ver contenidos borrados, ni editar directamente contenidos de otros.
  ESTADO_ADMIN = 3
  ESTADO_GESTOR_USR = 4
  ESTADO_SUPERADMIN = 5
  ESTADOS = [ESTADO_BANEADO, ESTADO_DESHABILITADO, ESTADO_SIN_ACTIVAR, ESTADO_NORMAL, ESTADO_MODERADOR, ESTADO_ADMIN, ESTADO_GESTOR_USR, ESTADO_SUPERADMIN]
  # Select para entradas de muros
  SELECT_ENTRADAS = "contenidos.publicado, contenidos.id, contenidos.inicial_id, contenidos.titulo, contenidos.texto_completo, contenidos.usuario_id, contenidos.usr_nick, contenidos.usr_nick_limpio, contenidos.subtipo_id, contenidos.contenido_link, contenidos.blog_id, contenidos.votos_count, contenidos.respuestas_count, contenidos.producto_id, contenidos.votos_link, contenidos.created_at"
  SELECT_LISTADOS_USUARIOS = "usuarios.id, usuarios.nick, usuarios.nick_limpio, usuarios.posicion_ranking, usuarios.puntos, usuarios.created_at, avatar_file_name, avatar_content_type, avatar_file_size avatar_updated_at"

  EL_TIO_DEL_FOREX = 71971

  has_attached_file :avatar, styles: {
                                        dia: "100x100>",
                                        thumbnail: "50x50>",
                                        cthumbnail: "50x50#",
                                        coment: "75x75>",
                                        ccoment: "75x75#",
                                        grande: "150x150>"
                                      },
                                      default_url: "/images/avatar_:style.gif",
                                      url: ":s3_eu_url",
                                      storage: :s3,
                                      s3_credentials: S3_CONFIG,
                                      path: "/images/avatar/:id_:style.:extension"

  validates_attachment_content_type :avatar, :content_type=>['image/jpeg', 'image/jpg', 'image/png', 'image/gif', "image/pjpeg", "image/x-png"], :message => '- No es un formato reconocido'
  validates :pais_id, presence: { message: "Falta seleccionar el país" }

  def nombre_apellidos
    [nombre, apellidos].join(' ').squish
  end

end
