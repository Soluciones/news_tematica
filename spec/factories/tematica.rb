FactoryGirl.define do
  factory :tematica do
    nombre        { Faker::Lorem.word }
    seccion_publi { Faker::Lorem.word }
  end
end
