# Coding: utf-8

module NewsTematica
  class NewsTematica < ActiveRecord::Base

    extend Clases
    include Clases
    include newsletter_helper_class

    belongs_to :tematica, class_name: ::NewsTematica::Clases.tematica_extern
    has_many :redirections, class_name: ::NewsTematica::Clases.redirection_extern
    has_many :suscripciones, foreign_key: 'tematica_id', primary_key: 'tematica_id'

    validates :tematica_id, :titulo, :banner_1_url_imagen, :banner_1_url_destino, :banner_1_texto_alt, :banner_2_url_imagen, :banner_2_url_destino, :banner_2_texto_alt, presence: true

    scope :enviada, -> { where enviada: true}

    MAX_ANTIGUEDAD = 7.days

    def calcula_fecha_desde
      ultima_de_misma_tematica = NewsTematica.enviada.where(tematica_id: tematica_id).order('fecha_hasta DESC').first
      self.fecha_desde = ultima_de_misma_tematica ? [ultima_de_misma_tematica.fecha_hasta, MAX_ANTIGUEDAD.ago].max : MAX_ANTIGUEDAD.ago
    end

    def enviar!
      suscribible = general? ? ::NewsTematica::Clases.tematica_extern.constantize.dame_general : tematica
      enviar_newsletter_a_suscriptores_suscribible(suscribible,
                                                   titulo,
                                                   html,
                                                   nombre_newsletter: titulo,
                                                   momento_envio: fecha_envio)
      self.update_attribute('enviada', true)
    end

    def general?
      !tematica
    end

    def nombre
      tematica_class.nombre_suscripcion(tematica_id)
    end
  end
end
