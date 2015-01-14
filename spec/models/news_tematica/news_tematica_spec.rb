require 'spec_helper'

describe NewsTematica do
  let(:tematica) { FactoryGirl.create(:tematica) }

  describe "calcula_fecha_desde" do
    before { allow(Time).to receive(:now).and_return(Time.parse('Feb 24 2013')) }

    it "debe devolver 'hace una semana' si no hay news anteriores de esta temática" do
      news = FactoryGirl.build(:news_tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end

    it "debe devolver 'hace una semana' si la última news de esta temática es antigua" do
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 03 2013"))
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 01 2013"))
      FactoryGirl.create(:news_tematica, fecha_hasta: Time.parse("Feb 22 2013"))
      news = FactoryGirl.build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end

    it "debe devolver la fecha_hasta de la última news de esta temática, si es reciente y está enviada" do
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 20 2013"), enviada: false)
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 19 2013"), enviada: true)
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 18 2013"), enviada: true)
      FactoryGirl.create(:news_tematica, fecha_hasta: Time.parse("Feb 22 2013"), enviada: true)
      news = FactoryGirl.build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 19 2013')
    end

    it "debe devolver 'hace una semana', si la única reciente no está enviada" do
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 20 2013"), enviada: false)
      news = FactoryGirl.build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end
  end

  describe "#enviar!" do
    describe "cuando es una newsletter de una temática" do
      subject { FactoryGirl.create(:news_tematica, tematica: tematica) }

      it "llama a enviar_newsletter_a_suscriptores_suscribible con la tematica a la que pertenece" do
        expect(subject).to receive(:enviar_newsletter_a_suscriptores_suscribible)
               .with(tematica, anything, anything, anything)

        subject.enviar!
      end
    end

    describe "cuando es una newsletter general" do
      subject do
        FactoryGirl.create(:news_tematica) do |news_tematica|
          news_tematica.update_attributes(tematica_id: nil)
        end
      end

      it "llama a enviar_newsletter_a_suscriptores_suscribible con la tematica general" do
        tematica_class = ::NewsTematica::Clases.tematica_extern.constantize

        expect(subject).to receive(:enviar_newsletter_a_suscriptores_suscribible)
               .with(an_instance_of(tematica_class), anything, anything, anything)

        subject.enviar!
      end
    end
  end
end
