# coding: UTF-8

class Blog < ActiveRecord::Base
  has_many :contenidos
  belongs_to :ultimo_post, class_name: 'Contenido'
  belongs_to :pais
  has_and_belongs_to_many :usuarios

  validates :titulo, presence: { on: :create }
  validates :orden, presence: { on: :create }
  validates :url,
    presence: { on: :create },
    uniqueness: true
  validates :pais, presence: true

  delegate :codigo_iso, to: :pais

  scope :con_ultimo_post, select('blog_id, blogs.titulo as titulo_blog, blogs.descripcion, blogs.url, blogs.posts_count, c.titulo as titulo_contenido, c.contenido_link, c.created_at, c.publicado').where(estado_id: 1).joins('INNER JOIN contenidos c ON blogs.ultimo_post_id = c.id')
  scope :in_locale, lambda { |locale| where(locale => true) }

  attr_accessor :lista_autores

  ESTADO_CERRADO = -1
  ESTADO_BLOGGER = 0
  ESTADO_ACTIVO = 1
  POST_POR_PAGINA = 10
  POST_EN_LO_MAS = 10
  TITULO_CONSULTORIO = 'Consulta al autor del blog'
  BLOGS_SIN_COMENTARIOS = ['cfds-igmarkets-cfd']
  BLOGS_OBSOLETOS = %w(sistemas-automaticos analisis-coginvestivo gestibolsa)
  BLOGS_EN_TITLE_DE_POST = %w(fernan2 diccionario-financiero)
  DICCIONARIO = 155
  FXPRO = 206
  FUTUROS = 213
  SISTEMAS = %w(sistemas-automaticos-trading sistemas-de-trading sistemas-trading ea-expert-advisors)

  def dominio
    mi_cache('dominio_por_pais_id', 'GET', pais_id)
  end

  def to_param
    url
  end
end
