class Story < ApplicationRecord
  has_many :article_stories, dependent: :delete_all
  has_many :articles, through: :article_stories
  has_one :last_created_article, ->{ by_article_created }, class_name: 'ArticleStory'

  def count_types
    articles.select(:article_type).distinct.count
  end
end
