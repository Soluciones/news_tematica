require 'spec_helper'

describe NewsTematica do
  let(:tematica) { create(:tematica) }

  describe "calcula_fecha_desde" do
    before { allow(Time).to receive(:now).and_return(Time.parse('Feb 24 2013')) }

    it "debe devolver 'hace una semana' si no hay news anteriores de esta temática" do
      news = build(:news_tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end

    it "debe devolver 'hace una semana' si la última news de esta temática es antigua" do
      create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 03 2013"))
      create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 01 2013"))
      create(:news_tematica, fecha_hasta: Time.parse("Feb 22 2013"))
      news = build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end

    it "debe devolver la fecha_hasta de la última news de esta temática, si es reciente y está enviada" do
      create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 20 2013"), enviada: false)
      create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 19 2013"), enviada: true)
      create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 18 2013"), enviada: true)
      create(:news_tematica, fecha_hasta: Time.parse("Feb 22 2013"), enviada: true)
      news = build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 19 2013')
    end

    it "debe devolver 'hace una semana', si la única reciente no está enviada" do
      create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 20 2013"), enviada: false)
      news = build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end
  end

  pending '#enviar!'
end
