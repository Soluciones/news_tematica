# coding: utf-8

HTTP_DOMINIOS = {
  ar: "http://www.rankia.com.ar",
  cl: "http://www.rankia.cl",
  co: "http://www.rankia.co",
  es: "http://www.rankia.com",
  mx: "http://www.rankia.mx",
  pe: "http://www.rankia.pe" }

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
end
