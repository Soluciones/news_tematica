# coding: UTF-8

FactoryGirl.define do
  factory :veces_leido do
    association   :leido, factory: :tema
    contador      100
    leido_dia     5
    leido_semana  30
  end
end
