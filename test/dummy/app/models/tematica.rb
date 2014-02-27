# coding: UTF-8

class Tematica < ActiveRecord::Base
  validates :nombre, presence: true
  validates :seccion_publi, presence: true

  NOMBRE_GENERAL = "General"

  def to_param
    "#{id}-#{nombre.tag2url}"
  end

  def self.datos_dropdown
    self.dame_todas_sin_general
  end

  def self.dame_general
    Tematica.find_or_create_by_nombre(NOMBRE_GENERAL)
  end

  def self.dame_todas_sin_general
    tematicas = mi_cache('tematicas')
    tematicas.select { |tematica| tematica.nombre != NOMBRE_GENERAL }
  end

  def self.nombre(id, nombre_si_no_se_encuentra = 'temática desconocida')
    tematica = mi_cache('tematicas').select{ |t| t.id == id.to_i }.first
    tematica ? tematica.nombre : nombre_si_no_se_encuentra
  end

end
