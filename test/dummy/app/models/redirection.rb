# coding: UTF-8

class Redirection < ActiveRecord::Base
  has_many :visitas

  def num_visitas
    visitas.sin_contar_robots.count
  end
end
