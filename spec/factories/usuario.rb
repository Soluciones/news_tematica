# coding: UTF-8

FactoryGirl.define do
  factory :usuario do
    nombre            { Faker::Name.first_name }
    apellidos         { Faker::Name.last_name }
    nick              { |u| "a" + Faker::Internet.user_name(u.nombre)[0..12]+SecureRandom.hex(3) }
    nick_limpio       { |u| u.nick.tag2url }
    email             { Faker::Internet.email }
    password          "123456"
    pass_sha          "7c4a8d09ca3762af61e59520943dc26494f8941b" # El resultado de codificar 123456
    pais              { Pais.find_or_create_by_nombre(nombre: "España")}
    provincia_id      1
    estado_id         { Usuario::ESTADO_NORMAL }
    puntos            { rand(100) }
    cod_postal        '28080'
    posicion_ranking  { 50 + rand(1000) }
    dominio_de_alta   { 'es' }

    factory :admin do
      estado_id { Usuario::ESTADO_ADMIN }
    end

    factory :gestor_usr do
      estado_id { Usuario::ESTADO_GESTOR_USR }
    end

    factory :moderador do
      estado_id { Usuario::ESTADO_MODERADOR }
    end

    factory :usuario_con_telefono do
      telefono '961234567'
    end

    factory :superadmin do
      estado_id { Usuario::ESTADO_SUPERADMIN }
    end

    factory :usuario_juego_bolsa do
      telefono '961234567'
      juego_bolsa true
      juego_bolsa_activado true
    end

    factory :usuario_con_estadisticas do
      ignore do
        estadisticas_totales 5
      end
      after(:create) do |usuario, evaluator|
        subtipo = Subtipo.first || FactoryGirl.create(:subtipo)
        FactoryGirl.create_list(:estadistica, evaluator.estadisticas_totales, usuario: usuario, subtipo: subtipo)
      end
    end

    factory :usuario_con_favoritos do
      after(:create) do |usuario, evaluator|
        usuario.favoritismos << FactoryGirl.create(:favoritismo_usuario, usuario: usuario)
        usuario.save
      end
    end

    factory :usuario_baneado do
      estado_id Usuario::ESTADO_BANEADO
    end

    factory :usuario_deshabilitado do
      estado_id Usuario::ESTADO_DESHABILITADO
    end

    factory :usuario_no_activado do
      estado_id Usuario::ESTADO_SIN_ACTIVAR
    end

    factory :usuario_moderador do
      estado_id Usuario::ESTADO_MODERADOR
    end

    factory :usuario_sin_provincia do
      provincia_id nil
      cod_postal nil
    end

    factory :usuario_suscrito_a do
      ignore do
        tematica nil
      end

      after(:create) do |usuario, evaluator|
        usuario.suscripciones.create(tematica: evaluator.tematica, dominio_de_alta: usuario.dominio_de_alta)
      end
    end
  end
end
