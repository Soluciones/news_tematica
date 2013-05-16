# coding: UTF-8

ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural(/a$/i, '\1as')

  inflect.irregular 'pais', 'paises'
  inflect.irregular 'opinion', 'opiniones'
  inflect.irregular 'titular', 'titulares'
  inflect.irregular 'accion', 'acciones'
  inflect.irregular 'auto', 'auto'
  inflect.irregular 'hogar', 'hogar'
  inflect.irregular 'banca', 'banca'
  inflect.irregular 'inversion', 'inversion'
  inflect.irregular 'pension', 'pensiones'
  inflect.irregular 'fondo de inversión', 'fondos de inversión'
  inflect.irregular 'plan de pensiones', 'planes de pensiones'
  inflect.irregular 'seguro de auto', 'seguros de auto'
  inflect.irregular 'seguro de hogar', 'seguros de hogar'
  inflect.irregular 'simulador', 'simuladores'
  inflect.irregular 'shorten', 'shorten'
  inflect.irregular 'promocion', 'promociones'
  inflect.irregular 'suscripcion', 'suscripciones'
  inflect.irregular 'captador', 'captadores'
end
