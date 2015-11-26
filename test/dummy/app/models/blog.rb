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

  scope :in_locale, lambda { |locale| where(locale => true) }

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
