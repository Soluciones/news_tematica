$ ->
  $('.js_ver_resto_titulares').click ->
    $('.js_resto_titulares').slideDown()
    $(this).hide()

  $('#cb_titulares, #cb_foros, #cb_mas_leidos').click ->
    estado = @checked
    $(this).parent().next().find(':checkbox').each ->
      @checked = estado
      undefined
