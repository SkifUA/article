class Article < ApplicationRecord
  has_many :article_stories, dependent: :delete_all
  has_many :stories, through: :article_stories

  scope :name_cant, ->(input) { where('name LIKE ?', "%#{input}%") }
  scope :article_type_cant, ->(input) { where('article_type LIKE ?', "%#{input}%") }
  scope :text_cant, ->(input) { where('text LIKE ?', "%#{input}%") }


  def self.allowed_orders
    [:id, :name, :article_type, :created_at, :updated_at, :text]
  end

  def self.allowed_scopes
    [:name_cant, :article_type_cant, :text_cant]
  end

end
