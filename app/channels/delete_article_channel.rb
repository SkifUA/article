
class DeleteArticleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "delete_article"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end