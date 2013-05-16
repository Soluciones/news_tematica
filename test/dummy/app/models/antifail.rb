# coding: UTF-8

class Antifail < ActiveRecord::Base
  CALCULO_DOMINIO = 'No se ha podido resolver el dominio'
  CANONICAL_RELATIVA = 'Canonical relativa'
  RESOLVER_DOMINIO = 'Campos insuficientes para resolver dominio'
  RESOLVER_VISIBILIDAD = 'Campos insuficientes para resolver visibilidad'
end
