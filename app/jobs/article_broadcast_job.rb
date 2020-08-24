class ArticleBroadcastJob < ApplicationJob
  def perform(article)
    ArticlesChannel.server.broadcast "article", article
  end
end