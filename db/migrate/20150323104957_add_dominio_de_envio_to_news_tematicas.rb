class AddDominioDeEnvioToNewsTematicas < ActiveRecord::Migration
  def change
    add_column :news_tematica_news_tematicas, :dominio_de_envio, :string
  end
end
