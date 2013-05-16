# coding: utf-8

require 'spec_helper'

describe NewsTematica::NewsTematicasController do
  render_views  # Necesario para que funcione el render_to_string usado para generar el html

  let(:mi_news_tematica) { FactoryGirl.create(:news_tematica, tematica: Tematica.find_by_nombre('Bolsa')) }

  describe "contenidos_elegidos" do
    it "sólo pueden acceder admins" do
      ApplicationController.any_instance.should_receive(:admin_required)
      post :contenidos_elegidos, id: mi_news_tematica.id
    end

    it "debe generar un HTML con dichos contenidos, en el orden correcto" do
      login_controller(FactoryGirl.create(:admin))
      mensaje_raso = FactoryGirl.create(:tema, created_at: 3.days.ago)
      titular_muy_leido = FactoryGirl.create(:tema_titular, fecha_titulares: 1.hour.ago, created_at: 3.hours.ago, bolsa: true)
      mensaje_muy_recomendado = FactoryGirl.create(:tema, created_at: 3.days.ago, votos_count: 20, respuestas_count: 3)
      FactoryGirl.create(:veces_leido, leido: titular_muy_leido, contador: 5000)
      FactoryGirl.create(:veces_leido, leido: mensaje_muy_recomendado, contador: 100)
      FactoryGirl.create(:veces_leido, leido: mensaje_raso, contador: 100)
      post :contenidos_elegidos, id: mi_news_tematica.id, titulares: "#{mensaje_muy_recomendado.id},#{mensaje_raso.id}", masleidos:  "#{mensaje_muy_recomendado.id},#{titular_muy_leido.id}", temas: mensaje_raso.id.to_s
      response.should redirect_to edit_news_tematica_path(mi_news_tematica)
      mi_news_tematica.reload
      mi_news_tematica.html.should have_css("#titular_0 a[href='http://www.rankia.com#{ mensaje_muy_recomendado.contenido_link }']")
      mi_news_tematica.html.should have_css("#titular_1 a[href='http://www.rankia.com#{ mensaje_raso.contenido_link }']")
      mi_news_tematica.html.should have_css("#masleido_0 a[href='http://www.rankia.com#{ titular_muy_leido.contenido_link }']")
      mi_news_tematica.html.should have_css("#masleido_1 a[href='http://www.rankia.com#{ mensaje_muy_recomendado.contenido_link }']")
      mi_news_tematica.html.should have_css("#tema_0 a[href='http://www.rankia.com#{ mensaje_raso.contenido_link }']")
    end
  end

  describe "update" do
    it "sólo pueden acceder admins" do
      ApplicationController.any_instance.should_receive(:admin_required)
      post :update, id: mi_news_tematica.id
    end

    it "debe prohibir cambiar news ya enviadas" do
      login_controller(FactoryGirl.create(:admin))
      mi_news_tematica.update_attribute('enviada', true)
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: 'Cambio' }
      mi_news_tematica.reload
      mi_news_tematica.titulo.should_not == 'Cambio'
    end

    it "debe permitir cambiar news no enviadas" do
      login_controller(FactoryGirl.create(:admin))
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: 'Cambio' }
      mi_news_tematica.reload
      mi_news_tematica.titulo.should == 'Cambio'
      response.should redirect_to news_tematica.edit_news_tematica_path(mi_news_tematica)
    end

    it "debe editar de nuevo si falla al guardar" do
      login_controller(FactoryGirl.create(:admin))
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: '' }
      mi_news_tematica.reload
      mi_news_tematica.titulo.should_not == ''
      response.should render_template('news_tematicas/edit')
    end

    it "debe llamar al envío por sendgrid si se ha usado el botón de sendgrid y todo está bien" do
      login_controller(FactoryGirl.create(:admin))
      NewsTematica::NewsTematica.any_instance.should_receive(:a_sendgrid!)
      post :update, id: mi_news_tematica.id, news_tematica: { titulo: 'SendGrid' }, commit: 'Guardar y Enviar vía SendGrid'
      mi_news_tematica.reload
      mi_news_tematica.titulo.should == 'SendGrid'
      response.should redirect_to news_tematicas_path
    end
  end

  describe "index" do
    it "sólo pueden acceder admins" do
      ApplicationController.any_instance.should_receive(:admin_required)
      get :index
    end
  end
end
