require 'spec_helper'

describe NewsTematica do
  let(:tematica) { build_stubbed(:tematica) }

  describe '#destinatarios' do
    context 'de una news que se envía a todos los dominios' do
      let(:news) { build(:news_tematica, suscribible: tematica, dominio_de_envio: nil) }

      context 'con alguien suscrito a ese suscribible desde varios dominios' do
        let(:alguien) { build_stubbed(:usuario) }
        before do
          create(:suscripcion, suscriptor: alguien, suscribible: tematica, dominio_de_alta: 'es')
          create(:suscripcion, suscriptor: alguien, suscribible: tematica, dominio_de_alta: 'mx')
        end

        it 'debe recibir un solo email de esta news' do
          expect(news.destinatarios.pluck(:email)).to eq([alguien.email])
        end
      end
    end
  end

  describe 'calcula_fecha_desde' do
    before { allow(Time).to receive(:now).and_return(Time.parse('Feb 24 2013')) }

    it "debe devolver 'hace una semana' si no hay news anteriores de esta temática" do
      news = build(:news_tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end

    it "debe devolver 'hace una semana' si la última news de esta temática es antigua" do
      create(:news_tematica, suscribible: tematica, fecha_hasta: Time.parse('Feb 03 2013'))
      create(:news_tematica, suscribible: tematica, fecha_hasta: Time.parse('Feb 01 2013'))
      create(:news_tematica, fecha_hasta: Time.parse('Feb 22 2013'))
      news = build(:news_tematica, suscribible: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end

    it 'debe devolver la fecha_hasta de la última news de esta temática, si es reciente y está enviada' do
      create(:news_tematica, suscribible: tematica, fecha_hasta: Time.parse('Feb 20 2013'), enviada: false)
      create(:news_tematica, suscribible: tematica, fecha_hasta: Time.parse('Feb 19 2013'), enviada: true)
      create(:news_tematica, suscribible: tematica, fecha_hasta: Time.parse('Feb 18 2013'), enviada: true)
      create(:news_tematica, fecha_hasta: Time.parse('Feb 22 2013'), enviada: true)
      news = build(:news_tematica, suscribible: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 19 2013')
    end

    it "debe devolver 'hace una semana', si la única reciente no está enviada" do
      create(:news_tematica, suscribible: tematica, fecha_hasta: Time.parse('Feb 20 2013'), enviada: false)
      news = build(:news_tematica, suscribible: tematica)
      news.calcula_fecha_desde
      expect(news.fecha_desde).to eq Time.parse('Feb 17 2013')
    end
  end

  describe '#enviar!' do
    let(:news_tematica) { create(:news_tematica) }
    before do
      allow(news_tematica).to receive(:enviar_a)
      allow(news_tematica).to receive(:sleep)
    end

    shared_examples 'news con estado de envío' do
      it 'la news queda marcada como enviada' do
        expect { news_tematica.enviar! }.to change { news_tematica.enviada }.from(false).to(true)
      end
    end

    context 'cuando hay suscripciones' do
      let(:suscripciones) { [double(Suscribir::Suscripcion)] }

      it_behaves_like 'news con estado de envío'

      before do
        allow(news_tematica)
          .to receive_message_chain(:destinatarios, :find_in_batches)
          .and_yield(suscripciones)
      end

      it 'envia la temática a los suscriptores' do
        expect(news_tematica).to receive(:enviar_a).with(suscripciones)
        news_tematica.enviar!
      end

      it 'descansa entre las peticiones de envío' do
        expect(news_tematica).to receive(:sleep)
        news_tematica.enviar!
      end
    end

    context 'cuando no hay suscripciones' do
      it_behaves_like 'news con estado de envío'

      before do
        allow(news_tematica).to receive_message_chain(:suscribible, :suscripciones, :activas)
          .and_return(Suscribir::Suscripcion.none)
      end

      it 'no envia la temática a los suscriptores' do
        expect(news_tematica).not_to receive(:enviar_a)
        news_tematica.enviar!
      end

      it 'no realiza descansos' do
        expect(news_tematica).not_to receive(:sleep)
        news_tematica.enviar!
      end
    end
  end
end
