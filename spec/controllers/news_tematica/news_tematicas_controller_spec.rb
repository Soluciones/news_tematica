# coding: utf-8

require 'spec_helper'

describe NewsTematicas::NewsTematicasController do
  render_views  # Necesario para que funcione el render_to_string usado para generar el html

  let(:news_tematica) { FactoryGirl.create(:news_tematica, tematica: Tematica.find_by_nombre('Bolsa')) }

  describe "contenidos_elegidos" do
    it "sólo pueden acceder admins" do
      login_controller(FactoryGirl.create(:usuario))
      post :contenidos_elegidos, id: news_tematica.id
      response.should redirect_to main_app.login_path
    end

    it "debe generar un HTML con dichos contenidos, en el orden correcto" do
      login_controller(FactoryGirl.create(:admin))
      mensaje_raso = FactoryGirl.create(:tema, created_at: 3.days.ago)
      titular_muy_leido = FactoryGirl.create(:tema_titular, fecha_titulares: 1.hour.ago, created_at: 3.hours.ago, bolsa: true)
      mensaje_muy_recomendado = FactoryGirl.create(:tema, created_at: 3.days.ago, votos_count: 20, respuestas_count: 3)
      FactoryGirl.create(:veces_leido, leido: titular_muy_leido, contador: 5000)
      FactoryGirl.create(:veces_leido, leido: mensaje_muy_recomendado, contador: 100)
      FactoryGirl.create(:veces_leido, leido: mensaje_raso, contador: 100)
      post :contenidos_elegidos, id: news_tematica.id, titulares: "#{mensaje_muy_recomendado.id},#{mensaje_raso.id}", masleidos:  "#{mensaje_muy_recomendado.id},#{titular_muy_leido.id}", temas: mensaje_raso.id.to_s
      response.should redirect_to edit_news_tematica_path(news_tematica)
      news_tematica.reload
      news_tematica.html.should have_css("#titular_0 a[href='http://www.rankia.com#{ mensaje_muy_recomendado.contenido_link }']")
      news_tematica.html.should have_css("#titular_1 a[href='http://www.rankia.com#{ mensaje_raso.contenido_link }']")
      news_tematica.html.should have_css("#masleido_0 a[href='http://www.rankia.com#{ titular_muy_leido.contenido_link }']")
      news_tematica.html.should have_css("#masleido_1 a[href='http://www.rankia.com#{ mensaje_muy_recomendado.contenido_link }']")
      news_tematica.html.should have_css("#tema_0 a[href='http://www.rankia.com#{ mensaje_raso.contenido_link }']")
    end
  end

  describe "update" do
    it "sólo pueden acceder admins" do
      login_controller(FactoryGirl.create(:usuario))
      post :update, id: news_tematica.id
      response.should redirect_to main_app.login_path
    end

    it "debe prohibir cambiar news ya enviadas" do
      login_controller(FactoryGirl.create(:admin))
      news_tematica.update_attribute('enviada', true)
      post :update, id: news_tematica.id, news_tematica: { titulo: 'Cambio' }
      news_tematica.reload
      news_tematica.titulo.should_not == 'Cambio'
    end

    it "debe permitir cambiar news no enviadas" do
      login_controller(FactoryGirl.create(:admin))
      post :update, id: news_tematica.id, news_tematica: { titulo: 'Cambio' }
      news_tematica.reload
      news_tematica.titulo.should == 'Cambio'
      response.should redirect_to edit_news_tematica_path(news_tematica)
    end

    it "debe editar de nuevo si falla al guardar" do
      login_controller(FactoryGirl.create(:admin))
      post :update, id: news_tematica.id, news_tematica: { titulo: '' }
      news_tematica.reload
      news_tematica.titulo.should_not == ''
      response.should render_template('news_tematicas/edit')
    end

    it "debe llamar al envío por sendgrid si se ha usado el botón de sendgrid y todo está bien" do
      login_controller(FactoryGirl.create(:admin))
      NewsTematica.any_instance.should_receive(:a_sendgrid!)
      post :update, id: news_tematica.id, news_tematica: { titulo: 'SendGrid' }, commit: 'Guardar y Enviar vía SendGrid'
      news_tematica.reload
      news_tematica.titulo.should == 'SendGrid'
      response.should redirect_to news_tematicas_path
    end

  end
end
