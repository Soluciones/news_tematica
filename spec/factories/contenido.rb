FactoryGirl.define do
  factory :contenido, aliases: [:suscribible] do
    transient do
      debo_aceptar_contenido true
    end
    titulo          { FFaker::Lorem.sentence.to_s }
    association     :usuario
    subtipo         { Subtipo.first || FactoryGirl.create(:subtipo) }
    texto_completo  { FFaker::Lorem.paragraphs.join('<br/><br/>') }
    usr_nick        { usuario.nick }
    usr_nick_limpio { usuario.nick_limpio }
    es              true
    
    factory :titular do
      contenido_link      { FFaker::Internet.http_url }
      subtipo_id          { Subtipo::TITULARES }
      tema                { Subtipo::TITULARES }
      publicado           true
      fecha_titulares     { 1.minute.ago }
      created_at          { fecha_titulares }
    end
  end
end
