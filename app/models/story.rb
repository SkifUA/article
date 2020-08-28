class Story < ApplicationRecord
  has_and_belongs_to_many :articles, through: :article_stories
  has_and_belongs_to_many :last_article, ->{ order(created_at: :desc).limit(1) }, class_name: 'Article'

  before_update :update_types_count
  before_create :set_created_types_count
  before_save :update_article_counts

  def count_types
    articles.pluck(:article_type).uniq.count
  end

  def self.allowed_orders
    [:id, :name, :articles_count, :created_at, :updated_at, :types_count]
  end

  def self.allowed_scopes
    [:name_cant]
  end

  def calculate_types_count
    articles.pluck(:article_type).uniq.count
  end

  private

  def update_types_count
    self.types_count = calculate_types_count
  end

  def set_created_types_count
    self.types_count = Article.where(id: article_ids).pluck(:article_type).uniq.count
  end

  def update_article_counts
    self.articles_count = article_ids.count
  end
end
