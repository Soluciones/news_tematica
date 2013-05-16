# coding: UTF-8

class Foto < ActiveRecord::Base
  belongs_to :contenido, counter_cache: true
  belongs_to :usuario

  attr_accessor :image_url

  # ------------------------------------
  # CÓMO REPROCESAR TODAS LAS FOTOS
  # ------------------------------------
  # Abrir la consola de rails y:
  # rais c production
  # fotos = foto.all
  # fotos.select { |f| f.adjunto.reprocess! if f.adjunto.exists? }
  # ------------------------------------
  # POSIBLES PROBLEMAS
  # Para reprocesarlas es imprescindible que exista la foto NOMBRE_original.jpg , si no existe porque se llama diferente (En attatchment_fu era NOMBRE.jpg)
  # se puede usar la interpolación que hay en application.rb que se llama "no_original_style":
  # :path => "images/valoraciones/:id_particion/:basename:no_original_style.:extension"

  # Un arreglo para desde la consola arreglar las imágenes mal enlazadas
  # for c in Contenido.where('publicado').all do
  #     c.update_attributes(:texto_completo => c.texto_completo.gsub(/\/respuestas\/(\d*)\/images\/(\d*)/,'/respuestas/\1/fotos/\2'))
  #     c.save
  #   end
  #
  #   for c in Fragmento.all do
  #     c.update_attributes(:texto_renderizado => c.texto_renderizado.gsub(/\/respuestas\/(\d*)\/images\/(\d*)/,'/respuestas/\1/fotos/\2'))
  #     c.save
  #   end
  #


  # :path => ":rails_root/public/images/valoraciones/:id_particion/:basename_:style.:extension",
  # :url => "images/valoraciones/:id_particion/:basename_:style.:extension",
  has_attached_file :adjunto,
                                :styles => {
                                  :thumb => '100>',
                                  :col => '300>',
                                  :foro => '420>'
                                },
                                :default_url => "images/valoraciones/404_:style.gif",
                                :url  => ":s3_eu_url",
                                :storage => :s3,
                                :s3_credentials => S3_CONFIG,
                                :path => "images/valoraciones/:id_particion/:basename:no_original_style.:extension"

  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'

  validates_attachment_presence :adjunto, :message => '- Debe elegir un archivo para subirlo'
  validates_attachment_size :adjunto, :less_than => 1.megabyte, :message => '- El tamaño máximo es de 1 mega'
  validates_attachment_content_type :adjunto, :content_type=>['image/jpeg', 'image/jpg', 'image/png', 'image/gif', "image/pjpeg", "image/x-png"], :message => '- No es un formato reconocido'

  # SOBRE EL ORDEN DE LAS IMAGENES
  # ///////////////////////////////////////
  # El 0 es la imagen principal (el "logo" de un producto por ejemplo). El resto es el orden en el que se mostrarían
  # Un orden de -1 (negativo) indica una imagen aportada por un usuario a un contenido en concreto (se muestra dentro del propio contenido, por lo que no es editable este orden)

  # Devuelve TRUE si el usuario está autorizado a modificar o eliminar un criterio.
  # El criterio es que los admins pueden hacerlo siempre, y el autor también
  def autorizado?(usuario)
    usuario.admin?  or  (usuario.id == self.usuario_id)
  end

  def padre
    if self.contenido_id
      Contenido.find_by_id(self.contenido_id)
    else
      Producto.find_by_id(self.producto_id)
    end
  end

  # Reprocesa una imagen regenerando sus miniaturas
  def reprocesar
    self.adjunto.reprocess!
  end


private

  def image_url_provided?
    !self.image_url.blank?
  end

  def download_remote_image
    self.adjunto = do_download_remote_image
    self.image_remote_url = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last.gsub('%20', ' ').gsub('%C3%A1', 'á').gsub('%C3%A9', 'é').gsub('%C3%AD', 'í').gsub('%C3%B3', 'ó').gsub('%C3%BA', 'ú').gsub('%C3%81', 'Á').gsub('%C3%89', 'É').gsub('%C3%8D', 'Í').gsub('%C3%93', 'Ó').gsub('%C3%9A', 'Ú').gsub('%C3%B1', 'ñ').gsub('%C3%91', 'Ñ').gsub('%C3%A7', 'ç').gsub('%C3%87', 'Ç').gsub('%C3%BC', 'ü').gsub('%C3%9C', 'Ü'); end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

end
