# coding: UTF-8

require "spec_helper"

describe NewsTematica::ApplicationHelper do
  describe "max_caracteres_con_palabras_enteras" do
    it 'Debe devolver la frase entera si no desborda la longitud' do
      max_caracteres_con_palabras_enteras('Hola mundo', 50).should == 'Hola mundo'
    end
    it 'Debe devolver la frase cortada pero sin partir palabras si desborda la longitud' do
      max_caracteres_con_palabras_enteras('Hola mundo', 7).should == 'Hola'
    end
  end
end
