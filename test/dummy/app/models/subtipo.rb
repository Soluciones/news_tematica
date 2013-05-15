# coding: UTF-8

class Subtipo < ActiveRecord::Base

  F_BANCOS = 1
  BOLSA = 2
  F_DEPOSITOS = 3  # Foro depósitos
  F_HIPOTECAS = 4
  SEGUROS = 5
  JUEGO = 6
  CLUB = 7
  AFINSA = 8
  EUROBANK = 9
  ACCIONES = 10
  BANCOS = 11
  BROKERS = 12
  CUENTAS = 13
  DEPOSITOS = 14  # Producto Depósito. El f_depósitos es el foro
  HIPOTECAS = 15
  FONDOS = 16
  PLANES = 17
  COCHE = 18
  HOGAR = 19
  TARJETAS = 20
  ARTICULOS = 21
  COMENTARIOS = 22
  TITULARES = 23
  OPINIONES = 24 # Agregado de las opiniones para el ranking
  ECONOMIA = 25
  TECNICO = 26
  PREFERENTES = 27
  FISCALIDAD = 28
  POSTS = 29
  CONSUMO = 30
  EMPRESAS = 31
  SISTEMAS = 32
  DEOLEO = 33
  FOROFONDOS = 34
  VIDEOS = 35
  QUABIT = 36
  AR_BANCA = 37
  AR_BOLSA = 38
  CL_BANCA = 39
  CL_BOLSA = 40
  CO_BANCA = 41
  CO_BOLSA = 42
  MX_BANCA = 43
  MX_BOLSA = 44
  PE_BANCA = 45
  PE_BOLSA = 46
  # ARRAY_PRODUCTOS_CON_ENTIDAD lo utilizo en el master_prod_ontroller para cvalidar que el autocomplete que muestra el nombre de la entidad ha sido rellenado.
  ARRAY_PRODUCTOS_CON_ENTIDAD = [CUENTAS, DEPOSITOS, HIPOTECAS, BANCOS, BROKERS, FONDOS, PLANES, COCHE, HOGAR, TARJETAS ]
  # Si se da de alta un nuevo foro, hay que actualizar todas estas constantes.
  # Aparte de eso, también hay que meterlo en el ranking de usuarios
  ARRAY_FOROS = [F_BANCOS,F_DEPOSITOS,F_HIPOTECAS,SEGUROS,EMPRESAS,FISCALIDAD,CONSUMO,ECONOMIA,PREFERENTES,BOLSA,JUEGO,CLUB,AFINSA,EUROBANK,TECNICO, SISTEMAS, DEOLEO, FOROFONDOS, QUABIT, AR_BOLSA, AR_BANCA, CL_BOLSA, CL_BANCA, CO_BOLSA, CO_BANCA, MX_BOLSA, MX_BANCA, PE_BOLSA, PE_BANCA]
  LISTA_FOROS = ARRAY_FOROS.join(", ")
  ARRAY_FOROS_PRIVADOS = [TECNICO, SISTEMAS, DEOLEO, QUABIT]
  ARRAY_FOROS_BASURA = [CLUB, AFINSA, EUROBANK]
  ARRAY_FOROS_NORMALES = ARRAY_FOROS - ARRAY_FOROS_PRIVADOS - ARRAY_FOROS_BASURA

  ARRAY_FOROS_VISIBLES = {
    ar: [AR_BANCA, AR_BOLSA],
    cl: [CL_BANCA, CL_BOLSA],
    co: [CO_BANCA, CO_BOLSA],
    es: [F_BANCOS, F_DEPOSITOS, FOROFONDOS, F_HIPOTECAS, SEGUROS, EMPRESAS, FISCALIDAD, CONSUMO, ECONOMIA, PREFERENTES, BOLSA, JUEGO],
    mx: [MX_BANCA, MX_BOLSA],
    pe: [PE_BANCA, PE_BOLSA] }


  ARRAY_FOROS_DEL_PAIS = {
    ar: ARRAY_FOROS_VISIBLES[:ar],
    cl: ARRAY_FOROS_VISIBLES[:cl],
    co: ARRAY_FOROS_VISIBLES[:co],
    es: ARRAY_FOROS_VISIBLES[:es] + ARRAY_FOROS_BASURA + ARRAY_FOROS_PRIVADOS,
    mx: ARRAY_FOROS_VISIBLES[:mx],
    pe: ARRAY_FOROS_VISIBLES[:pe] }

  FOROS_BOLSA = { ar: AR_BOLSA, cl: CL_BOLSA, co: CO_BOLSA, es: BOLSA, mx: MX_BOLSA, pe: PE_BOLSA }
  FOROS_BANCA = { ar: AR_BANCA, cl: CL_BANCA, co: CO_BANCA, es: F_BANCOS, mx: MX_BANCA, pe: PE_BANCA }

  COLUMNAS_RANKING = %w(nick_limpio puntos fans votos rk usuario Foro_Bancos Foro_Bolsa Foro_Depósitos Foro_Fondos Foro_Hipotecas Foro_Seguros Foro_Preferentes Foro_Economía Foro_Consumo Foro_Fiscalidad Foro_Empresas Foro_Desafío opiniones posts) # Los foros deben coincidir con los foros_visibles
  ARRAY_OPINIONES = [ACCIONES, BANCOS, BROKERS, CUENTAS, DEPOSITOS, HIPOTECAS, FONDOS, PLANES, COCHE, HOGAR, TARJETAS]
  LISTA_OPINIONES = ARRAY_OPINIONES.join(", ")
  ARRAY_OPINIONES_BANCA = [BANCOS, CUENTAS, DEPOSITOS, FONDOS, PLANES, TARJETAS]
  ARRAY_COMENTABLES = ARRAY_OPINIONES + [ARTICULOS, POSTS]
  LISTA_COMENTABLES = ARRAY_COMENTABLES.join(', ')
  ARRAY_ETIQUETABLES = ARRAY_FOROS + [ARTICULOS, POSTS, TITULARES]
  LISTA_ETIQUETABLES = ARRAY_ETIQUETABLES.join(', ')
  FOROS_EN_HOME = [F_BANCOS, BOLSA, F_DEPOSITOS, FOROFONDOS, F_HIPOTECAS, SEGUROS, CONSUMO, FISCALIDAD, EMPRESAS].join(", ")
  ARRAY_PERFIL_PUBLICO = ARRAY_FOROS + ARRAY_OPINIONES + [ARTICULOS, COMENTARIOS, POSTS]
  LISTA_PERFIL_PUBLICO = ARRAY_PERFIL_PUBLICO.join(", ")
  TYPE = ['','', '', '', '', '', '', '', '', '', 'Accion', 'Banca', 'Broker', 'Cuenta', 'Deposito', 'Hipoteca', 'Inversion', 'Pension', 'Auto', 'Hogar', 'Tarjeta', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''] # Se usa para sacar el type partiendo del subtipo_id
  PUNTOS_CORTO = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 50, 1, 40, 10, 1, 0, 1, 1, 10, 1, 1, 0, 0, 1, 10, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  PUNTOS_LARGO = [0, 5, 5, 5, 5, 5, 5, 5, 2, 1, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 50, 5, 40, 10, 5, 0, 5, 5, 30, 5, 5, 0, 0, 5, 10, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
  PUNTOS_MUY_LARGO = [0, 10, 10, 10, 10, 10, 10, 10, 4, 2, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 50, 10, 40, 25, 10, 0, 10, 10, 50, 10, 10, 0, 0, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
  LONGITUD_LARGO = [0, 99, 99, 99, 99, 99, 99, 99, 99, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 0, 0, 99, 0, 99, 99, 1000, 99, 99, 0, 0, 99, 0, 0, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99]
  LONGITUD_MUY_LARGO = [0, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 0, 300, 0, 0, 300, 0, 300, 300, 3000, 300, 300, 0, 0, 300, 0, 0, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300]
  ESTRELLA_GRIS = ['', 'foro-banco', 'foro-bolsa', 'foro-depositos', 'foro-hipotecas', 'foro-seguros', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'foro-economia-politica', '', 'foro-participaciones-preferentes', 'foro-fiscalidad-impuestos', '', 'foro-consumo-ahorro', 'foro-empresas-autonomos', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']
  PUNTOS_POR_RECOMENDAR = 1
  PUNTOS_POR_RECOMENDADO = 5
  PUNTOS_POR_FAVORITO = 50
  PUNTOS_POR_FAVORITO_RECIPROCO = 50
  ARRAY_SUBTIPOS_RANKING = ARRAY_FOROS_VISIBLES[:es] + [POSTS, OPINIONES]


  # En los foros, cuenta el nº de hilos y actualiza el puntero al último
  SQL_TEMAS = "UPDATE subtipos s SET
      productos_temas_count = (SELECT Count(*) FROM contenidos c WHERE c.tema = s.id),
      ultimo_producto_tema = (SELECT MAX(id) FROM contenidos c WHERE c.tema = s.id) "
  # En los productos, cuenta el nº de productos y actualiza el puntero al último
  SQL_PRODUCTOS = "UPDATE subtipos s SET
      productos_temas_count = (SELECT Count(*) FROM productos p WHERE p.subtipo_id = s.id AND p.publicado = true),
      ultimo_producto_tema = (SELECT MAX(id) FROM productos p WHERE p.subtipo_id = s.id AND p.publicado = true AND p.ultima_valoracion IS NOT NULL) "

end
