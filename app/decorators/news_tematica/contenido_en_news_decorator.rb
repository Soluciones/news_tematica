# coding: UTF-8

class ContenidoEnNewsDecorator < Draper::Decorator
  delegate_all

  def foto_para_news
    h.image_tag(fotos.first.adjunto.url(:col), alt: fotos.first.titulo) if fotos.first
  end
end
