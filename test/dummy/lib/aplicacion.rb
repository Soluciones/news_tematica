HTTP_DOMINIOS = {
  ar: "http://www.midominio.com.ar",
  cl: "http://www.midominio.cl",
  co: "http://www.midominio.co",
  es: "http://www.midominio.com",
  mx: "http://www.midominio.mx",
  pe: "http://www.midominio.pe" }

PAISES = [:ar, :cl, :co, :es, :mx, :pe]

class String
  def quita_acentos
    result = self.gsub(/[áàäâå]/, 'a').gsub(/[éèëê]/, 'e').gsub(/[íìïî]/, 'i').gsub(/[óòöô]/, 'o').gsub(/[úùüû]/, 'u')
    result = result.gsub(/[ÁÀÄÂÅ]/, 'A').gsub(/[ÉÈËÊ]/, 'E').gsub(/[ÍÌÏÎ]/, 'I').gsub(/[ÓÒÖÔ]/, 'O').gsub(/[ÚÙÜÛ]/, 'U')
    result = result.gsub(/[ýÿ]/, 'y').gsub(/[Ñ]/, 'N').gsub(/[ñ]/, 'n').gsub(/[Ç]/, 'C').gsub(/[ç]/, 'c')
  end

  def simbolos2guion
    sin_simbolos = self.gsub(/[^a-zA-Z0-9-]/, '-').gsub('----', '-').gsub('---', '-').gsub('--', '-')
    sin_guion_ppio_ni_final = sin_simbolos.sub(/\A-(.*)/, '\1').sub(/(.*)-\z/, '\1')
  end

  def tag2url
    String.new(self.quita_acentos.downcase.simbolos2guion)
  end

  def quita_nokeyws
    array_limpio = (self.split("-").compact.uniq || [])
    # Ojo, no concatenar operaciones de delete, que lo que hacen es tocar el original, no devolver el resultado
    array_limpio.delete("")
    array_limpio.quita_nokeys.join("-")
  end

  # Monta la URL con las keywords, unidas con guiones, y quitando las ñ y ç que no deben ir en URLs
  def to_url
    self.tag2url.quita_nokeyws
  end

  def lanza_sql(modo = nil)
    # El modo update devuelve el nº de registros afectados; sin él, recibiríamos NIL.
    (modo == 'update') ? ActiveRecord::Base.connection.update(self) : ActiveRecord::Base.connection.execute(self)
  end
  # Si una cadena es blank, se cambia por la alternativa
  def o_si_no(alternativa)
    self.strip.blank? ? alternativa : self
  end

end


class NilClass
  # Si una cadena es blank o nil, se cambia por la alternativa
  def o_si_no(alternativa)
    alternativa
  end
  def downcase
    ''
  end
end

class Array
  # Le quita a un array de palabras las que no voy a considerar keywords para la URL (diccionario de nokeys propio)
  def quita_nokeys
    self - %w(a ademas al algo algun alguno ante aquel aqui bajo bien cabe con cuya cuyo cuyas cuyos de da del desde e el en entre es ese este ha han hasta la las le les lo los me mi muy nos o os pero quot quote se sin sobre su tan te tras tu u un una unos unas y ya yo)
  end
end

