# coding: UTF-8

module UsuariosHelper
  def login(usuario)
    visit login_path
    fill_in "Usuario:", with: usuario.nick
    fill_in "usuario_password", with: "123456"
    click_button "Entrar"
  end

  def login_controller(usuario = FactoryGirl.create(:usuario))
    session[:usuario_id] = usuario.id
  end

  def logout
    visit logout_path
  end
end


shared_context "login usuario controller" do
  let(:usuario) { FactoryGirl.create(:usuario) }
  before { session[:usuario_id] = usuario.id }
end

shared_context "login usuario admin controller" do
  let(:usuario) { FactoryGirl.create(:admin) }
  before { session[:usuario_id] = usuario.id }
end

shared_context "login usuario con estadisticas controller" do
  let(:usuario) { FactoryGirl.create(:usuario) }
  before { session[:usuario_id] = usuario.id }
end
