class Story < ApplicationRecord
  has_many :article_stories, dependent: :delete_all
  has_many :articles, through: :article_stories
  has_one :last_created_article, ->{ by_article_created }, class_name: 'ArticleStory'

  scope :sort_by_id,             ->(order = :asc) { order(id: order) }
  scope :sort_by_name,           ->(order = :asc) { order(name: order) }
  scope :sort_by_articles_count, ->(order = :asc) { order(articles_count: order) }
  scope :sort_by_created_at,     ->(order = :asc) { order(created_at: order) }
  scope :sort_by_updated_at,     ->(order = :asc) { order(updated_at: order) }

  def count_types
    articles.pluck(:article_type).uniq.count
  end

  def self.ransackable_scopes(auth_object = nil)
    [:sort_by_id, :sort_by_name, :sort_by_articles_count, :sort_by_created_at, :sort_by_updated_at]
  end

  def self.ransackable_scopes_skip_sanitize_args
    self.ransackable_scopes
  end
end
