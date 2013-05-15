class AddEnviadaToNewsTematicas < ActiveRecord::Migration
  def change
    add_column :news_tematica_news_tematicas, :enviada, :boolean, default: false
  end
end
