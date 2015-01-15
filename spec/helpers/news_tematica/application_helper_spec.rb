require "spec_helper"

describe NewsTematica::ApplicationHelper, type: :helper do
  describe "link_to_con_estadisticas" do
    let(:redirection_class) { ::NewsTematica::Clases.redirection_extern.constantize }
    let(:mi_news_tematica) { FactoryGirl.create(:news_tematica) }
    let(:request) {
      request = double('source')
      allow(request).to receive(:host).and_return('test.host')
      request
    }

    it "debe crear la redirección, si no existe, y devolver enlace que usa la redireccion" do
      result = link_to_con_estadisticas('Hola Poldo', '/ejemplo', mi_news_tematica, class: 'link-ppal')
      expect(redirection_class.count).to eq 1
      expect(redirection_class.where(url: '/ejemplo', news_tematica_id: mi_news_tematica.id).count).to eq 1
      expect(result).to eq link_to('Hola Poldo', "http://test.host/redirections/#{redirection_class.first.id}",
                                   class: 'link-ppal')
    end

    it "debe usar la redirección que ya existe, y devolver enlace que usa la redireccion" do
      result = link_to_con_estadisticas('Hola Poldo', '/ejemplo', mi_news_tematica, class: 'link-ppal')
      result2 = link_to_con_estadisticas('Adiós Poldo', '/ejemplo', mi_news_tematica, class: 'pingback')
      expect(redirection_class.count).to eq 1
      expect(redirection_class.where(url: '/ejemplo', news_tematica_id: mi_news_tematica.id).count).to eq 1
      expect(result2).to eq link_to('Adiós Poldo', "http://test.host/redirections/#{redirection_class.first.id}",
                                    class: 'pingback')
    end
  end
end
