class Article < ApplicationRecord
  has_and_belongs_to_many :stories

  before_destroy :update_stories_by_destroy

  attribute :group
  attribute :group_value

  scope :name_cont, ->(input) { where('name LIKE ?', "%#{input}%") }
  scope :article_type_cont, ->(input) { where('article_type LIKE ?', "%#{input}%") }
  scope :text_cont, ->(input) { where('text LIKE ?', "%#{input}%") }
  scope :name_or_text_cont, ->(input) { name_cont(input).or(text_cont(input))}
  # scope :wherever_cont, ->(input) do
  #   where('name LIKE ? OR article_type LIKE ? OR text LIKE ?', "%#{input}%", "%#{input}%", "%#{input}%")
  # end
  scope :last_created, ->{ order(created_at: :desc).limit(1) }

  def self.allowed_orders
    ['articles.id', 'articles.name', 'articles.article_type', 'articles.created_at',
     'articles.updated_at', 'articles.text']
  end

  def self.allowed_scopes
    [:name_cont, :article_type_cont, :text_cont, :name_or_text_cont]
  end


  private

  def update_stories_by_destroy
    data = stories.includes(:articles).map do |story|
      latest_article_id = story.articles.present? ? story.articles.sort_by { |a| a.created_at }.last.id : nil
      article_types = story.articles.map(&:article_type)
      types_number = article_types.group_by{ |e| e }.select { |_k, v| v.size > 1 }.map(&:first).include?(article_type) ?
                         story.types_count :
                         story.types_count - 1

      [
          story.id,
          { articles_count: story.articles_count - 1, types_count: types_number, latest_article_id: latest_article_id }
      ]
    end

    Story.batch_update(data.to_h) if data.present?
  end
end
