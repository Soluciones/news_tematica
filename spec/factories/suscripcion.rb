FactoryGirl.define do
  factory :suscripcion, class: Suscribir::Suscripcion do
    association :suscribible
    association :suscriptor
    email { suscriptor.email }
    dominio_de_alta 'es'
  end
end
