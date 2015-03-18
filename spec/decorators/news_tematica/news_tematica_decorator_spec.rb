require 'spec_helper'

describe NewsTematica::NewsTematicaDecorator do
  describe "html_con_contadores" do
    let(:visita_class) { ::NewsTematica::Clases.visita_extern.constantize }
    it "debe añadir los contadores de visitas a los enlaces" do
      pocos_clics = 3
      muchos_clics = 6
      redirection_id_pocos_clics = 124
      redirection_id_muchos_clics = 125
      create_list(:visita, pocos_clics, redirection_id: redirection_id_pocos_clics)
      create_list(:visita, muchos_clics, redirection_id: redirection_id_muchos_clics)
      link_con_pocos_clics = "<a href=\"http://midominio.com/redirections/#{redirection_id_pocos_clics}\" style=\"colorlink\">spam</a>"
      link_con_pocos_clics_con_contador = "<span class=\"cuentaclics\">#{pocos_clics}</span><a href=\"http://midominio.com/redirections/#{redirection_id_pocos_clics}\" style=\"colorlink\">spam</a>"
      link_con_muchos_clics = "<a href=\"http://midominio.com/redirections/#{redirection_id_muchos_clics}\">spam</a>"
      link_con_muchos_clics_con_contador = "<span class=\"cuentaclics\">#{muchos_clics}</span><a href=\"http://midominio.com/redirections/#{redirection_id_muchos_clics}\">spam</a>"
      html = "<p>blabla #{link_con_pocos_clics} blabla #{link_con_pocos_clics} otro mas #{link_con_muchos_clics}</p>"
      html_con_contador = "<p>blabla #{link_con_pocos_clics_con_contador} blabla #{link_con_pocos_clics_con_contador} otro mas #{link_con_muchos_clics_con_contador}</p>"
      news_tematica = build(:news_tematica, html: html).decorate
      expect(news_tematica.html_con_contadores).to eq html_con_contador
    end
  end

  describe "#prioriza_como_te_diga" do
    context "con una lista de contenidos seleccionados y unas prioridades establecidas" do
      let(:news_tematica) { create(:news_tematica).decorate }
      let(:contenidos_seleccionables) { create_list(:contenido, 15) }
      let(:prioridades) do
        prioridades = {}
        contenidos_seleccionables.shuffle.each_with_index do |contenido, indice|
          prioridades[contenido.id.to_s] = (indice +1).to_s
        end
        prioridades
      end
      let(:contenidos_seleccionados) { contenidos_seleccionables[0..9] }

      it "devuelve la lista de contenidos ordenados por prioridad" do
        contenidos_priorizados = news_tematica.prioriza_como_te_diga(contenidos_seleccionados, prioridades)
        contenidos_priorizados.each_with_index do |contenido, indice|
          break unless (siguiente_contenido = contenidos_priorizados[indice + 1])

          expect(prioridades[contenido.id.to_s].to_i < prioridades[siguiente_contenido.id.to_s].to_i).to be true
        end
      end

      it "solo devuelve contenidos que han sido seleccionados" do
        contenidos_priorizados = news_tematica.prioriza_como_te_diga(contenidos_seleccionados, prioridades)
        expect(contenidos_priorizados.map(&:id)).to match_array contenidos_seleccionados.map(&:id)
      end
    end
  end
end
