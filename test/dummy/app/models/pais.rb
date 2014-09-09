# coding: UTF-8

class Pais < ActiveRecord::Base
  has_many :provincias
  has_many :usuarios
  has_many :subtipos

  validates :nombre, presence: true

  scope :con_dominio, -> { where(codigo_iso: PAISES.collect{ |p| p.to_s }) }

  def self.nombre(id)
    'Expaña'
  end

  def foros
    self.subtipos.where(id: Subtipo::ARRAY_FOROS)
  end
end
