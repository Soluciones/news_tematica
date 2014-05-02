# coding: utf-8

require 'spec_helper'

describe NewsTematica do
  describe "calcula_fecha_desde" do
    before { Time.stub(:now).and_return(Time.parse("Feb 24 2013")) }

    it "debe devolver 'hace una semana' si no hay news anteriores de esta temática" do
      news = FactoryGirl.build(:news_tematica)
      news.calcula_fecha_desde
      news.fecha_desde.should == Time.parse("Feb 17 2013")
    end

    it "debe devolver 'hace una semana' si la última news de esta temática es antigua" do
      tematica = FactoryGirl.create(:tematica)
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 03 2013"))
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 01 2013"))
      FactoryGirl.create(:news_tematica, fecha_hasta: Time.parse("Feb 22 2013"))
      news = FactoryGirl.build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      news.fecha_desde.should == Time.parse("Feb 17 2013")
    end

    it "debe devolver la fecha_hasta de la última news de esta temática, si es reciente y está enviada" do
      tematica = FactoryGirl.create(:tematica)
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 20 2013"), enviada: false)
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 19 2013"), enviada: true)
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 18 2013"), enviada: true)
      FactoryGirl.create(:news_tematica, fecha_hasta: Time.parse("Feb 22 2013"), enviada: true)
      news = FactoryGirl.build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      news.fecha_desde.should == Time.parse("Feb 19 2013")
    end

    it "debe devolver 'hace una semana', si la única reciente no está enviada" do
      tematica = FactoryGirl.create(:tematica)
      FactoryGirl.create(:news_tematica, tematica: tematica, fecha_hasta: Time.parse("Feb 20 2013"), enviada: false)
      news = FactoryGirl.build(:news_tematica, tematica: tematica)
      news.calcula_fecha_desde
      news.fecha_desde.should == Time.parse("Feb 17 2013")
    end
  end
end
