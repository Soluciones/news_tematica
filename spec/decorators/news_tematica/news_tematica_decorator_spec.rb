# coding: UTF-8

require 'spec_helper'

describe NewsTematica::NewsTematicaDecorator do
  describe "html_con_contadores" do
    let(:visita_class) { ::NewsTematica::Clases.visita_extern.constantize }
    it "debe añadir los contadores de visitas a los enlaces" do
      pocos_clics = 3
      muchos_clics = 6
      redirection_id_pocos_clics = 124
      redirection_id_muchos_clics = 125
      FactoryGirl.create_list(:visita, pocos_clics, redirection_id: redirection_id_pocos_clics)
      FactoryGirl.create_list(:visita, muchos_clics, redirection_id: redirection_id_muchos_clics)
      link_con_pocos_clics = "<a href=\"http://midominio.com/redirections/#{redirection_id_pocos_clics}\" style=\"colorlink\">spam</a>"
      link_con_pocos_clics_con_contador = "<span class=\"cuentaclics\">#{pocos_clics}</span><a href=\"http://midominio.com/redirections/#{redirection_id_pocos_clics}\" style=\"colorlink\">spam</a>"
      link_con_muchos_clics = "<a href=\"http://midominio.com/redirections/#{redirection_id_muchos_clics}\">spam</a>"
      link_con_muchos_clics_con_contador = "<span class=\"cuentaclics\">#{muchos_clics}</span><a href=\"http://midominio.com/redirections/#{redirection_id_muchos_clics}\">spam</a>"
      html = "<p>blabla #{link_con_pocos_clics} blabla #{link_con_pocos_clics} otro mas #{link_con_muchos_clics}</p>"
      html_con_contador = "<p>blabla #{link_con_pocos_clics_con_contador} blabla #{link_con_pocos_clics_con_contador} otro mas #{link_con_muchos_clics_con_contador}</p>"
      news_tematica = FactoryGirl.build(:news_tematica, html: html).decorate
      news_tematica.html_con_contadores.should == html_con_contador
    end
  end
end
