# coding: UTF-8

FactoryGirl.define do
  factory :news_tematica do
    tematica      { FactoryGirl.create(:tematica) }
    titulo        { "Novedades de #{ tematica.nombre }" }
    fecha_envio   { 1.day.from_now }
    html          { "<h1>Hello world!</h1>" }
  end
end
