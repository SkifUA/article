class ArticleBroadcastJob < ApplicationJob
  def perform(article)
    ActionCable.server.broadcast "article", ArticleSerializer.new(article)
  end
end