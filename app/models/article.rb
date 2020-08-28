class Article < ApplicationRecord
  has_and_belongs_to_many :stories

  before_destroy :update_stories_counting

  scope :name_cant, ->(input) { where('name LIKE ?', "%#{input}%") }
  scope :article_type_cant, ->(input) { where('article_type LIKE ?', "%#{input}%") }
  scope :text_cant, ->(input) { where('text LIKE ?', "%#{input}%") }

  def self.allowed_orders
    [:id, :name, :article_type, :created_at, :updated_at, :text]
  end

  def self.allowed_scopes
    [:name_cant, :article_type_cant, :text_cant]
  end


  private

  def update_stories_counting
    data = stories.includes(:articles).map do |story|
      article_types = story.articles.map(&:article_type)
      types_number = article_types.group_by{ |e| e }.select { |_k, v| v.size > 1 }.map(&:first).include?(article_type) ?
                         story.types_count :
                         story.types_count - 1

      [story.id, { articles_count: story.articles_count - 1, types_count: types_number }]
    end

    Story.batch_update(data.to_h) if data.present?
  end
end
