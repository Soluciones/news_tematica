module NewsTematica
  class NewsTematica < ActiveRecord::Base
    extend Clases
    include Clases

    belongs_to :suscribible, polymorphic: true
    has_many :redirections, class_name: ::NewsTematica::Clases.redirection_extern

    validates :suscribible_id, :titulo, :banner_1_url_imagen, :banner_1_url_destino, :banner_1_texto_alt, :banner_2_url_imagen, :banner_2_url_destino, :banner_2_texto_alt, presence: true

    scope :enviada, -> { where enviada: true}

    delegate :nombre, to: :suscribible, path_prefix: false

    MAX_ANTIGUEDAD = 7.days

    def calcula_fecha_desde
      ultima_de_misma_tematica = NewsTematica.enviada.where(suscribible: suscribible).order(fecha_hasta: :desc).first
      self.fecha_desde = if ultima_de_misma_tematica
                           [ultima_de_misma_tematica.fecha_hasta, MAX_ANTIGUEDAD.ago].max
                         else
                           MAX_ANTIGUEDAD.ago
                         end
    end

    def enviar!
      suscribible.suscripciones.activas.en_dominio(dominio_de_envio).find_in_batches do |grupo_suscripciones|
        enviar_a(grupo_suscripciones)
        sleep(1)
      end
      update_attribute(:enviada, true)
    end

    def enviar_preview_a!(yo)
      suscripcion_fake = Suscribir::Suscripcion.new(suscriptor: yo, suscribible: suscribible, id: -1, email: yo.email)
      enviar_a([suscripcion_fake])
    end

    def general?
      suscribible.is_a?(Suscribir::Newsletter)
    end

    def self.nueva_con_fechas_por_defecto(suscribible)
      new(suscribible: suscribible, fecha_hasta: Time.zone.now, fecha_envio: 1.year.from_now)
    end

    private

    def vars_para_newsletter(suscripciones)
      suscripciones.map do |suscripcion|
        { rcpt: suscripcion.email,
          vars: [{ name: 'url_desuscripcion_tematica', content: suscripcion.decorate.url_desuscribir }] }
      end
    end

    def enviar_a(suscripciones)
      message = {
        subject: titulo,
        from_name: ESTA_WEB,
        from_email: ConstantesEmail::INFO,
        to: suscripciones.map { |suscripcion| { email: suscripcion.email } },
        html: html,
        merge_vars: vars_para_newsletter(suscripciones),
        preserve_recipients: false
      }

      mandrill_client = Mandrill::API.new Rails.application.secrets.mandrill_password
      mandrill_client.messages.send message
    end
  end
end
