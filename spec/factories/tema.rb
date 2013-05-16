# coding: UTF-8

FactoryGirl.define do
  factory :tema, parent: :contenido, aliases: [:hilo], class: Tema do
    ignore do
      visibilidad_por_defecto true
    end
    subtipo         { Subtipo.find(Subtipo::BOLSA) }

    before(:create) do |tema, evaluator|
      tema.stub(:asigna_visibilidad) unless evaluator.visibilidad_por_defecto
    end

    after(:create) do |tema, evaluator|
      tema.inicial_id = tema.id
      tema.contenido_link = "/foros/#{tema.subtipo.permalink}/temas/#{tema.id}-#{tema.titulo.to_url}"
      tema.votos_link = "/foros/#{tema.subtipo.permalink}/respuestas/#{tema.id}-#{tema.titulo.to_url}"
      tema.save
      tema.acepta_contenido if evaluator.debo_aceptar_contenido
    end

    factory :tema_no_publicado do
      debo_aceptar_contenido false
    end

    factory :tema_titular do
      fecha_titulares { 10.minutes.ago }
      descripcion     { Faker::Lorem.sentences.join("/r/n") }
    end
  end
end
