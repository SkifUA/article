class UpdateStoryTypesCountJob < ApplicationJob
  def perform(story_ids)
    story_ids.each do |story_id|
      Story.find_by(id: story_id).save
    end
  end
end