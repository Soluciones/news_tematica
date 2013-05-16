# coding: UTF-8

class Tema < Contenido
  HILOS_EN_LISTA = 36

  # belongs_to :foro, foreign_key: 'subtipo_id'

  def mi_url
    "#{Subtipo.url(self.subtipo_id)}/#{self.id}-#{self.titulo.to_url}"
  end

end
