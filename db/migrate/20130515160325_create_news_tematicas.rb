class CreateNewsTematicas < ActiveRecord::Migration
  def change
    create_table :news_tematica_news_tematicas do |t|
      t.integer :tematica_id
      t.string :titulo
      t.text :html
      t.datetime :fecha_desde
      t.datetime :fecha_hasta
      t.datetime :fecha_envio

      t.timestamps
    end
  end
end
