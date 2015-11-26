require 'rails_helper'

describe NewsTematica::NewsTematicaDecorator do
  describe 'locale_para_enlaces' do
    it 'should return :es when dominio_de_envio is blank' do
      expect(build(:news_tematica, dominio_de_envio: nil).decorate.locale_para_enlaces).to eq(:es)
      expect(build(:news_tematica, dominio_de_envio: '').decorate.locale_para_enlaces).to eq(:es)
    end

    it 'should return :mx when dominio_de_envio is "mx"' do
      expect(build(:news_tematica, dominio_de_envio: 'mx').decorate.locale_para_enlaces).to eq(:mx)
    end
  end

  describe 'remitente' do
    it 'should return info@midominio.com when dominio_de_envio is :es' do
      expect(build(:news_tematica, dominio_de_envio: 'es').decorate.remitente).to eq('info@midominio.com')
    end

    it 'should return info.mx@midominio.com when dominio_de_envio is :mx' do
      expect(build(:news_tematica, dominio_de_envio: 'mx').decorate.remitente).to eq('info.mx@midominio.com')
    end

    it 'should return info.xx@midominio.com when dominio_de_envio is :xx' do
      expect(build(:news_tematica, dominio_de_envio: 'xx').decorate.remitente).to eq('info.xx@midominio.com')
    end
  end

  describe 'titulares' do
    let!(:titular_mx) { create(:titular, mx: true, es: false, fecha_titulares: 1.day.ago) }
    let!(:titular_es) { create(:titular, mx: false, es: true, fecha_titulares: 1.day.ago) }
    let!(:titular_global) { create(:titular, mx: true, es: true, fecha_titulares: 1.day.ago) }
    let(:news) { create(:news_tematica, fecha_desde: 1.week.ago, fecha_hasta: Time.current).decorate }

    context 'en una news mexicana' do
      before { allow(news).to receive(:locale_para_enlaces) { :mx } }

      it 'devuelve titulares visibles en mx' do
        expect(news.titulares.map(&:id)).to match_array([titular_mx.id, titular_global.id])
      end
    end

    context 'en una news global o española' do
      before { allow(news).to receive(:locale_para_enlaces) { :es } }

      it 'devuelve titulares visibles en es' do
        expect(news.titulares.map(&:id)).to match_array([titular_es.id, titular_global.id])
      end
    end
  end

  describe 'temas' do
    let!(:tema_mx) { create(:tema, mx: true, es: false, created_at: 1.day.ago) }
    let!(:tema_es) { create(:tema, mx: false, es: true, created_at: 1.day.ago) }
    let!(:tema_global) { create(:tema, mx: true, es: true, created_at: 1.day.ago) }
    let(:news) { create(:news_tematica, fecha_desde: 1.week.ago, fecha_hasta: Time.current).decorate }

    context 'en una news mexicana' do
      before { allow(news).to receive(:locale_para_enlaces) { :mx } }

      it 'devuelve temas visibles en mx' do
        expect(news.temas.map(&:id)).to match_array([tema_mx.id, tema_global.id])
      end
    end

    context 'en una news global o española' do
      before { allow(news).to receive(:locale_para_enlaces) { :es } }

      it 'devuelve temas visibles en es' do
        expect(news.temas.map(&:id)).to match_array([tema_es.id, tema_global.id])
      end
    end
  end

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
