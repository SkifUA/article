class Story < ApplicationRecord
  has_many :article_stories, dependent: :delete_all
  has_many :articles, through: :article_stories
  has_one :last_created_article, ->{ by_article_created }, class_name: 'ArticleStory'

  before_save :set_types_count
  after_destroy :set_types_count

  scope :sort_by_article_id,     ->(order = :asc) { left_joins(:last_created_article).order("articles_stories.article_id #{order}") }

  def count_types
    articles.pluck(:article_type).uniq.count
  end

  def last_article
    articles.sort_by{ |a| a.created_at}.last
  end

  def self.allowed_orders
    [:id, :name, :articles_count, :created_at, :updated_at, :types_count, :'articles.id']
  end

  def self.allowed_scopes
    [:name_cant]
  end


  def calculate_types_count
    articles.pluck(:article_type).uniq.count
  end

  private

  def set_types_count
    self.types_count = calculate_types_count
  end
end
