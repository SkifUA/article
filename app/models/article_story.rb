class ArticleStory < ApplicationRecord
  self.table_name = 'articles_stories'

  belongs_to :article
  belongs_to :story, counter_cache: :articles_count

  scope :by_article_created, ->(order = :desc){ joins(:article).includes(:article).order("articles.created_at #{order}") }
end