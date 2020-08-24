class Article < ApplicationRecord
  has_many :article_stories, dependent: :delete_all
  has_many :stories, through: :article_stories

  after_save :article_broadcast


  def self.allowed_orders
    [:id, :name, :article_type, :created_at, :updated_at, :text]
  end

  def self.allowed_scopes
    []
  end

  private

  def article_broadcast
    ArticleBroadcastJob.perform_later(self)
  end

end
