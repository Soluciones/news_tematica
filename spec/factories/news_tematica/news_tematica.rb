FactoryGirl.define do
  factory :news_tematica, class: NewsTematica::NewsTematica do
    tematica      { FactoryGirl.create(:tematica) }
    titulo        { "Novedades de #{ tematica.nombre }" }
    fecha_envio   { 1.day.from_now }
    html          { "<h1>Hello world!</h1>" }
    banner_1_url_imagen { Faker::Internet.uri 'http' }
    banner_1_texto_alt { Faker::Lorem.sentence }
    banner_1_url_destino { Faker::Internet.uri 'http' }
    banner_2_url_imagen { Faker::Internet.uri 'http' }
    banner_2_texto_alt  { Faker::Lorem.sentence }
    banner_2_url_destino { Faker::Internet.uri 'http' }
  end
end
