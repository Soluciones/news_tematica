# coding: UTF-8

class Suscripcion < ActiveRecord::Base
  belongs_to :suscriptor, polymorphic: true
  belongs_to :tematica
  belongs_to :provincia

  scope :join_usuarios, joins("LEFT JOIN usuarios u ON u.id = suscripciones.suscriptor_id AND suscripciones.suscriptor_type = 'Usuario'")
  scope :total_por_provincias, select('COUNT(*) as total, suscripciones.provincia_id')
  scope :activos, join_usuarios.where("u.estado_id > ? or u.estado_id is null", Usuario::ESTADO_SIN_ACTIVAR)
  scope :con_tematica_si_viene, lambda{ |tematica_id| tematica_id.present? ? where(tematica_id: tematica_id) : nil }
  scope :con_dominio_si_viene, lambda{ |dominio| dominio.present? ? where(dominio_de_alta: dominio) : nil }
  scope :en_provincia_si_viene, lambda{ |provincias_id| provincias_id.present? ? where("suscripciones.provincia_id IN (?)", provincias_id) : nil}
  scope :de_desubicados, where("(suscripciones.provincia_id IS NULL OR suscripciones.provincia_id > 52)")
  scope :de_desubicados_y_de_provincias, lambda { |provincias_id| where("(suscripciones.provincia_id IN (?) OR suscripciones.provincia_id IS NULL OR suscripciones.provincia_id > 52)", provincias_id) }
  scope :totales_tematicas, lambda{ |locale|
    select('tematicas.nombre, tematicas.id, COUNT(suscripciones.id) AS n_suscripciones').
      activos.con_dominio_si_viene(locale).joins('RIGHT JOIN tematicas ON suscripciones.tematica_id = tematicas.id').
      group(:tematica_id).order('tematicas.nombre')
  }

  validates :nombre_apellidos, presence: true

  before_validation :cache_campos_suscripcion

  def self.dame_suscriptores_por_provincia(tematica_id = nil)
    suscripciones = Suscripcion.total_por_provincias.con_tematica_si_viene(tematica_id).con_dominio_si_viene('es').activos.group('suscripciones.provincia_id').all
    suscripciones_provincias_conocidas = suscripciones.select { |suscripciones_en_provincia| ((suscripciones_en_provincia.provincia_id.to_i > 0) and (suscripciones_en_provincia.provincia_id.to_i < 53)) }
    suscripciones_provincias_desconocidas = suscripciones.select { |suscripciones_en_no_provincia| (suscripciones_en_no_provincia.provincia_id.to_i == 0) or (suscripciones_en_no_provincia.provincia_id.to_i > 52) }
    provincias = []
    suscripciones_provincias_conocidas.each do |suscripciones_en_provincia|
      provincias << { id: suscripciones_en_provincia.provincia_id.to_i, nombre: Provincia.nombre(suscripciones_en_provincia.provincia_id), total: suscripciones_en_provincia.total }
    end
    return provincias << { id: 0, nombre: '', total: suscripciones_provincias_desconocidas.sum(&:total) }
  end

  def self.dame_lista_emails(locale = nil, tematica_id = nil, provincias_id = [])
    q = Suscripcion.con_tematica_si_viene(tematica_id).con_dominio_si_viene(locale).activos

    if provincias_id == [0]
      q = q.de_desubicados
    elsif provincias_id.include? 0
      q = q.de_desubicados_y_de_provincias(provincias_id)
    else
      q = q.en_provincia_si_viene(provincias_id)
    end
    q.all
  end

  def cache_campos_suscripcion
    if suscriptor
      self.nombre_apellidos = suscriptor.nombre_apellidos if suscriptor.respond_to? :nombre_apellidos
      self.email = suscriptor.email if suscriptor.respond_to? :email
      self.cod_postal = suscriptor.cod_postal if suscriptor.respond_to? :cod_postal
    end

    self.provincia_id = self.cod_postal[0..-4] if self.cod_postal.present?

    true
  end
end
