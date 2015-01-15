FactoryGirl.define do
  factory :contenido do
    transient do
      debo_aceptar_contenido true
    end
    titulo          { Faker::Lorem.sentence.to_s }
    association     :usuario
    subtipo         { Subtipo.first || FactoryGirl.create(:subtipo) }
    texto_completo  { Faker::Lorem.paragraphs.join('<br/><br/>') }
    usr_nick        { usuario.nick }
    usr_nick_limpio { usuario.nick_limpio }
    es              true
  end
end
