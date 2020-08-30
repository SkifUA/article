class Story < ApplicationRecord
  has_and_belongs_to_many :articles
  belongs_to :latest_article, class_name: 'Article', optional: true

  attribute :group
  attribute :group_value

  before_save :set_params_by_articles

  def count_types
    articles.pluck(:article_type).uniq.count
  end

  def self.allowed_orders
    ['stories.id', 'stories.name', 'stories.articles_count', 'stories.created_at',
     'stories.updated_at', 'stories.types_count', 'articles.id', :'articles.article_type']
  end

  def self.allowed_scopes
    [:name_cont]
  end

  def calculate_types_count
    articles.pluck(:article_type).uniq.count
  end


  private

  def update_types_count
    self.types_count = calculate_types_count
  end

  def set_params_by_articles
    _articles = Article.where(id: article_ids)
    self.latest_article_id = _articles.sort_by { |a| a.created_at }.last.id if _articles.present?
    self.types_count = _articles.map(&:article_type).uniq.count
    self.articles_count = article_ids.count
  end

  def update_article_counts
    self.articles_count = article_ids.count
  end
end
