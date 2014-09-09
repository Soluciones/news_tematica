# coding: UTF-8

class Visita < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :redirection

  scope :sin_contar_robots, -> { where('robot IS NULL') }

  delegate :nick, :nick_limpio, to: :usuario, allow_nil: true

end
