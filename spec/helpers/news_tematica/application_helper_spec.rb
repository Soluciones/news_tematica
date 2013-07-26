# coding: UTF-8

require "spec_helper"

describe NewsTematica::ApplicationHelper do
  describe "max_caracteres_con_palabras_enteras" do
    it 'Debe devolver la frase entera si no desborda la longitud' do
      max_caracteres_con_palabras_enteras('Hola mundo', 50).should == 'Hola mundo'
    end
    it 'Debe devolver la frase cortada pero sin partir palabras si desborda la longitud' do
      max_caracteres_con_palabras_enteras('Hola mundo', 7).should == 'Hola'
    end
  end

  describe "link_to_con_estadisticas" do
    let(:redirection_class) { ::NewsTematica::Clases.redirection_extern.constantize }
    let(:mi_news_tematica) { FactoryGirl.create(:news_tematica) }
    let(:request) {
      request = double('source')
      request.stub(:host).and_return('test.host')
      request
    }

    it "debe crear la redirección, si no existe, y devolver enlace que usa la redireccion" do
      result = link_to_con_estadisticas('Hola Poldo', '/ejemplo', mi_news_tematica, class: 'link-ppal')
      redirection_class.count.should == 1
      redirection_class.where(url: '/ejemplo', news_tematica_id: mi_news_tematica.id).count.should == 1
      result.should == link_to('Hola Poldo', "http://test.host/redirections/#{redirection_class.first.id}", class: 'link-ppal')
    end

    it "debe usar la redirección que ya existe, y devolver enlace que usa la redireccion" do
      result = link_to_con_estadisticas('Hola Poldo', '/ejemplo', mi_news_tematica, class: 'link-ppal')
      result2 = link_to_con_estadisticas('Adiós Poldo', '/ejemplo', mi_news_tematica, class: 'pingback')
      redirection_class.count.should == 1
      redirection_class.where(url: '/ejemplo', news_tematica_id: mi_news_tematica.id).count.should == 1
      result2.should == link_to('Adiós Poldo', "http://test.host/redirections/#{redirection_class.first.id}", class: 'pingback')
    end
  end
end
