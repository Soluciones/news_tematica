FactoryGirl.define do
  factory :suscripcion, class: Suscribir::Suscripcion do
    association :suscribible, factory: :contenido
    association :suscriptor, factory: :usuario
    email { suscriptor.email }
    dominio_de_alta 'es'
  end
end
