require 'rails_helper'

describe 'new' do
  context 'with a Tematica' do
    let(:suscribible) { create(:tematica, nombre: 'Poldadas') }

    it 'genera bien la news general' do
      visit "/news_tematicas/new?suscribible_id=#{suscribible.id}&suscribible_type=Tematica"
      expect(page.status_code).to be(200)
      expect(page).to have_css('h1', text: 'Nueva newsletter de Poldadas')
      click_button 'Generar'
      expect(page.status_code).to be(200)
      expect(page).to have_css('h1', text: 'Nueva newsletter de Poldadas')
    end
  end
end
