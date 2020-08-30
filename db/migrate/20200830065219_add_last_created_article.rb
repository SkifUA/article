class AddLastCreatedArticle < ActiveRecord::Migration[6.0]
  def change
    change_table :stories do |t|
      t.integer :latest_article_id
    end
  end
end
