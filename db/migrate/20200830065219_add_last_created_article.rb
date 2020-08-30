class AddLastCreatedArticle < ActiveRecord::Migration[6.0]
  def change
    change_table :stories do |t|
      t.references :latest_article, index: true, foreign_key: { to_table: :articles }
    end
  end
end
