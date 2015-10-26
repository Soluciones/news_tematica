require 'rails_helper'
require 'temping'

Temping.create :mi_suscribible do
  include Suscribir::Suscribible
  with_columns do |t|
    t.string(:nombre)
  end
end

describe 'new' do
  context 'with a Tematica' do
    let(:suscribible) { MiSuscribible.create!(nombre: 'Poldadas') }

    it 'genera bien la news general' do
      visit "/news_tematicas/new?suscribible_id=#{suscribible.id}&suscribible_type=MiSuscribible"
      expect(page.status_code).to be(200)
      expect(page).to have_css('h1', text: 'Nueva newsletter de Poldadas')
    end
  end
end
