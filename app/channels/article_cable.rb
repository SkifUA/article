class ArticleCable < ApplicationCable::Channel
  def subscribed
    stream_from "article_#{params[:story_id]}"
  end

  def unsubscribed
  end
end