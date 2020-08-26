class ArticleBroadcastJob < ApplicationJob
  def perform(article)
    ActionCable.server.broadcast 'articles', data: ArticleSerializer.new(article)
  end
end