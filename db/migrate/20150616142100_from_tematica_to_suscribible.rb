class FromTematicaToSuscribible < ActiveRecord::Migration
  def up
    rename_column :news_tematica_news_tematicas, :tematica_id, :suscribible_id
    add_column :news_tematica_news_tematicas, :suscribible_type, :string, after: :suscribible_id
    execute "UPDATE news_tematica_news_tematicas SET suscribible_type = 'Tematica::Tematica' WHERE suscribible_id > 0"
    execute "UPDATE news_tematica_news_tematicas SET suscribible_type = 'Suscribir::Newsletter', suscribible_id = 1 WHERE suscribible_id = 0"
  end
  
  def down
    execute "UPDATE news_tematica_news_tematicas SET suscribible_id = 0 WHERE suscribible_type = 'Suscribir::Newsletter'"
    delete_column :news_tematica_news_tematicas, :suscribible_type
    rename_column :news_tematica_news_tematicas, :suscribible_id, :tematica_id
  end
end