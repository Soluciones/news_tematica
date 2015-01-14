FactoryGirl.define do
  sequence :n_unico do |n|
    "#{ n }-subtipo"
  end
  factory :subtipo do
    nombre            { "Subtipo #{ Faker::Name.last_name } #{ FactoryGirl.generate(:n_unico) }" }
    nombre_corto      { |s| s.nombre.sub('Subtipo ', '') }
    nombre_completo   { |s| "#{ s.nombre } completo" }
    permalink         { |s| s.nombre_corto.tag2url }
    position          1
  end
end
