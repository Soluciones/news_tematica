FactoryGirl.define do
  factory :tematica do
    nombre        { FFaker::Lorem.word }
    seccion_publi { FFaker::Lorem.word }
  end
end
