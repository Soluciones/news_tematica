require 'spec_helper'

describe NewsTematica::NewsTematicasController, type: :controller do
  render_views  # Necesario para que funcione el render_to_string usado para generar el html
  routes { NewsTematica::Engine.routes }

  let!(:mi_news_tematica) { FactoryGirl.create(:news_tematica, tematica: Tematica.find_by(nombre: 'Bolsa'),
                                               fecha_desde: 7.days.ago, fecha_hasta: 1.minute.ago) }
  let(:dominio) { 'test.host' }
  let(:admin) { FactoryGirl.create(:admin) }

  describe "contenidos_elegidos" do
    let(:mensaje_raso) do
      mensaje = FactoryGirl.create(:tema, created_at: 3.days.ago, titulo: 'CAF paga dividendo hoy')
      mensaje.tap { |mensaje| FactoryGirl.create(:veces_leido, leido: mensaje, contador: 100) }
    end

    let(:titular_muy_leido) do
      mensaje = FactoryGirl.create(:tema_titular, fecha_titulares: 1.hour.ago, created_at: 3.hours.ago,
                                   bolsa: true, titulo: 'Gana 2% semanal')
      mensaje.tap { |mensaje| FactoryGirl.create(:veces_leido, leido: mensaje, contador: 5000) }
    end

    let(:mensaje_muy_recomendado) do
      mensaje = FactoryGirl.create(:tema, created_at: 3.days.ago, votos_count: 20, respuestas_count: 3,
                                   titulo: 'El quinto elemento')
      mensaje.tap { |mensaje| FactoryGirl.create(:veces_leido, leido: mensaje, contador: 100) }
    end

    def post_contenidos_elegidos(prioridades_titulares = nil)
      post :contenidos_elegidos, id: mi_news_tematica.id,
        titulares: [mensaje_muy_recomendado.id.to_s, mensaje_raso.id.to_s],
        masleidos: [mensaje_muy_recomendado.id.to_s, titular_muy_leido.id.to_s],
        temas: [mensaje_raso.id.to_s], prioridades_titulares: prioridades_titulares
    end

    it "sólo pueden acceder admins" do
      expect_any_instance_of(ApplicationController).to receive(:admin_required)
      post_contenidos_elegidos
    end

    it "debe redirigir a la página de editar" do
      post_contenidos_elegidos

      expect(response).to redirect_to edit_news_tematica_path(mi_news_tematica)
    end

    it "debe generar las redirecciones para cada contenido" do
      post_contenidos_elegidos

      expect(Redirection.find_by(url: "http://www.midominio.com#{ mensaje_muy_recomendado.contenido_link }",
                                 news_tematica_id: mi_news_tematica.id)).not_to be_nil
      expect(Redirection.find_by(url: "http://www.midominio.com#{ mensaje_raso.contenido_link }",
                                 news_tematica_id: mi_news_tematica.id)).not_to be_nil
      expect(Redirection.find_by(url: "http://www.midominio.com#{ titular_muy_leido.contenido_link }",
                                 news_tematica_id: mi_news_tematica.id)).not_to be_nil
    end

    context "sin pasar prioridades de orden" do
      it "debe llamar al metodo prioriza" do
        expect_any_instance_of(NewsTematica::NewsTematicaDecorator).to receive(:prioriza).twice.and_call_original
        post_contenidos_elegidos
      end

      it "debe generar un HTML con dichos contenidos en el orden calculado" do
        post_contenidos_elegidos
        mi_news_tematica.reload

        redireccion_mensaje_muy_recomendado = Redirection
          .find_by(url: "http://www.midominio.com#{ mensaje_muy_recomendado.contenido_link }",
                   news_tematica_id: mi_news_tematica.id)
        redireccion_mensaje_raso = Redirection
          .find_by(url: "http://www.midominio.com#{ mensaje_raso.contenido_link }",
                   news_tematica_id: mi_news_tematica.id)
        redireccion_titular_muy_leido = Redirection
          .find_by(url: "http://www.midominio.com#{ titular_muy_leido.contenido_link }",
                   news_tematica_id: mi_news_tematica.id)

        expect(mi_news_tematica.html).to have_css(
          "#titular_0 a[href='http://#{dominio}/redirections/#{redireccion_mensaje_muy_recomendado.id}']")
        expect(mi_news_tematica.html).to have_css(
          "#titular_1 a[href='http://#{dominio}/redirections/#{redireccion_mensaje_raso.id}']")
        expect(mi_news_tematica.html).to have_css(
          "#masleido_0 a[href='http://#{dominio}/redirections/#{redireccion_titular_muy_leido.id}']")
        expect(mi_news_tematica.html).to have_css(
          "#masleido_1 a[href='http://#{dominio}/redirections/#{redireccion_mensaje_muy_recomendado.id}']")
        expect(mi_news_tematica.html).to have_css(
          "#tema_0 a[href='http://#{dominio}/redirections/#{redireccion_mensaje_raso.id}']")
      end
    end

    describe "pasando prioridades de orden" do
      let(:prioridades_titulares) do
        { mensaje_muy_recomendado.id => '23' }
      end

      it "debe llamar al metodo prioriza_como_te_diga" do
        expect_any_instance_of(NewsTematica::NewsTematicaDecorator).to receive(:prioriza_como_te_diga).and_call_original
        post_contenidos_elegidos(prioridades_titulares)
      end
    end
  end

  describe "edit" do
    it "sólo pueden acceder admins" do
      expect_any_instance_of(ApplicationController).to receive(:admin_required)
      get :edit, id: mi_news_tematica.id
    end

    it "debe redirigir al show en las newsletters ya enviadas" do
      mi_news_tematica.update_attribute('enviada', true)
      get :edit, id: mi_news_tematica.id
      expect(response).to redirect_to news_tematica_path(mi_news_tematica)
    end
  end

  describe "update" do
    it "sólo pueden acceder admins" do
      expect_any_instance_of(ApplicationController).to receive(:admin_required)
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: 'Cambio' }
    end

    it "debe prohibir cambiar news ya enviadas" do
      mi_news_tematica.update_attribute('enviada', true)
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: 'Cambio' }
      mi_news_tematica.reload
      expect(mi_news_tematica.titulo).not_to eq 'Cambio'
    end

    it "debe permitir cambiar news no enviadas" do
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: 'Cambio' }
      mi_news_tematica.reload
      expect(mi_news_tematica.titulo).to eq 'Cambio'
      expect(response).to redirect_to edit_news_tematica_path(mi_news_tematica)
    end

    it "debe editar de nuevo si falla al guardar" do
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: '' }
      mi_news_tematica.reload
      expect(mi_news_tematica.titulo).not_to be ''
      expect(response).to render_template('news_tematicas/edit')
    end

    it "debe llamar al envío por sendgrid si se ha usado el botón de sendgrid y todo está bien" do
      expect_any_instance_of(NewsTematica::NewsTematica).to receive(:enviar!)
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: 'SendGrid' }, commit: 'Guardar y Enviar vía SendGrid'
      mi_news_tematica.reload
      expect(mi_news_tematica.titulo).to eq 'SendGrid'
      expect(response).to redirect_to news_tematicas_path
    end
  end

  describe "index" do
    it "sólo pueden acceder admins" do
      expect_any_instance_of(ApplicationController).to receive(:admin_required)
      get :index
    end
  end
end
