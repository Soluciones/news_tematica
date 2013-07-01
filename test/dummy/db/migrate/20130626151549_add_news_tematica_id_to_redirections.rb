class AddNewsTematicaIdToRedirections < ActiveRecord::Migration
  def change
    add_column :redirections, :news_tematica_id, :integer
    add_index :redirections, [:news_tematica_id, :url]
   end
end
