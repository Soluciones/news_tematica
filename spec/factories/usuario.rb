FactoryGirl.define do
  factory :usuario, aliases: [:suscriptor] do
    nombre            { FFaker::Name.first_name }
    apellidos         { FFaker::Name.last_name }
    nick              { |u| "a" + FFaker::Internet.user_name(u.nombre)[0..12]+SecureRandom.hex(3) }
    nick_limpio       { |u| u.nick.tag2url }
    email             { FFaker::Internet.email }
    password          "123456"
    pass_sha          "7c4a8d09ca3762af61e59520943dc26494f8941b" # El resultado de codificar 123456
    pais_id           { 1 }
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
  end
end
