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
      mandrill_client = Mandrill::API.new Rails.application.secrets.mandrill_password
      suscribible.suscripciones.find_in_batches do |grupo_suscripciones|
        message = {
          subject: titulo,
          from_name: ESTA_WEB,
          from_email: ConstantesEmail::INFO,
          to: grupo_suscripciones.map { |suscripcion| { email: suscripcion.email } },
          html: html,
          merge_vars: vars_para_newsletter(grupo_suscripciones),
          preserve_recipients: false
        }

        mandrill_client.messages.send message
        sleep(2)
      end
      self.update_attribute('enviada', true)
    end

    def vars_para_newsletter(suscripciones)
      suscripciones.map do |suscripcion|
        { rcpt: suscripcion.email,
          vars: [{ name: 'enlace_desuscripcion_tematica',
                   content: suscripcion.decorate.enlace_desuscripcion_url('haz click aquí') }] }
      end
    end

    def general?
      !tematica
    end

    def nombre
      tematica_class.nombre_suscripcion(tematica_id)
    end

    def self.nueva_con_fechas_por_defecto(tematica_id)
      new(tematica_id: tematica_id, fecha_hasta: Time.zone.now, fecha_envio: 6.hours.from_now)
    end
  end
end
