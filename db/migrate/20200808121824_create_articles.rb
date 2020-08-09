class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.text :text
      t.string :article_type

      t.timestamps
    end
    create_table :stories do |t|
      t.string :name
      t.integer :articles_count, default: 0

      t.timestamps
    end

    create_table :articles_stories do |t|
      t.belongs_to :story
      t.belongs_to :article
    end
  end
end
