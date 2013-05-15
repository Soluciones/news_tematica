# coding: UTF-8

class Provincia < ActiveRecord::Base
  has_many :usuarios
  has_many :suscripciones
  belongs_to :pais

  validates :pais_id, presence: true
  validates :nombre, presence: true

  def self.nombre(id)
    'kkk'
  end
end
