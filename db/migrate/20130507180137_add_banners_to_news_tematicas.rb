class AddBannersToNewsTematicas < ActiveRecord::Migration
  def change
    add_column :news_tematica_news_tematicas, :banner_1_url_imagen, :string
    add_column :news_tematica_news_tematicas, :banner_1_url_destino, :string
    add_column :news_tematica_news_tematicas, :banner_1_texto_alt, :string
    add_column :news_tematica_news_tematicas, :banner_2_url_imagen, :string
    add_column :news_tematica_news_tematicas, :banner_2_url_destino, :string
    add_column :news_tematica_news_tematicas, :banner_2_texto_alt, :string
  end
end
