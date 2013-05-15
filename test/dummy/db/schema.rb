# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130513172618) do

  create_table "news_tematica_news_tematicas", :force => true do |t|
    t.integer  "tematica_id"
    t.string   "titulo"
    t.text     "html"
    t.datetime "fecha_desde"
    t.datetime "fecha_hasta"
    t.datetime "fecha_envio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_1_url_imagen"
    t.string   "banner_1_url_destino"
    t.string   "banner_1_texto_alt"
    t.string   "banner_2_url_imagen"
    t.string   "banner_2_url_destino"
    t.string   "banner_2_texto_alt"
    t.boolean  "enviada",              :default => false
  end

end
