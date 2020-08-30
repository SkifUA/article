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
  #   where('name LIKE ? OR article_type LIKE ? OR text LIKE ?', "%#{input}%", "%#{input}%", "%#{input}%")schema_migrations
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
      _articles = story.articles.select { |a| a.id != id}
      latest_article_id = _articles.present? ? _articles.sort_by { |a| a.created_at }.last.id : nil
      article_types_count = _articles.map(&:article_type).uniq.count

      [
          story.id,
          { articles_count: _articles.count, types_count: article_types_count, latest_article_id: latest_article_id }
      ]
    end

    Story.batch_update(data.to_h) if data.present?
  end
end
