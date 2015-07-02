FactoryGirl.define do
  factory :news_tematica, class: NewsTematica::NewsTematica do
    suscribible { FactoryGirl.create(:tematica) }
    titulo { "Novedades de #{ tematica.nombre }" }
    fecha_envio { 1.day.from_now }
    html '<h1>Hello world!</h1>'
    banner_1_url_imagen { FFaker::Internet.uri 'http' }
    banner_1_texto_alt { FFaker::Lorem.sentence }
    banner_1_url_destino { FFaker::Internet.uri 'http' }
    banner_2_url_imagen { FFaker::Internet.uri 'http' }
    banner_2_texto_alt { FFaker::Lorem.sentence }
    banner_2_url_destino { FFaker::Internet.uri 'http' }
  end
end
