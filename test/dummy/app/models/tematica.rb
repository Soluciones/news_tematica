class Tematica < ActiveRecord::Base
  validates :nombre, presence: true
  validates :seccion_publi, presence: true

  include Suscribir::Suscribible

  def to_param
    "#{id}-#{nombre.tag2url}"
  end
end
