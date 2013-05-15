# Coding: utf-8

module NewsTematica
  class NewsTematica < ActiveRecord::Base

    extend Clases
    include newsletter_helper_class

    belongs_to :tematica, class: NewsTematica.tematica

    validates :tematica_id, :titulo, presence: true

    scope :enviada, where(enviada: true)

    MAX_ANTIGUEDAD = 7.days

    def calcula_fecha_desde
      ultima_de_misma_tematica = NewsTematica.enviada.where(tematica_id: tematica_id).order('fecha_hasta DESC').first
      self.fecha_desde = ultima_de_misma_tematica ? [ultima_de_misma_tematica.fecha_hasta, MAX_ANTIGUEDAD.ago].max : MAX_ANTIGUEDAD.ago
    end

    def a_sendgrid!
      crear_y_cronificar_newsletter(tematica.suscripciones, titulo, html, nombre_newsletter: titulo, momento_envio: fecha_envio)
      self.update_attribute('enviada', true)
    end
  end
end
