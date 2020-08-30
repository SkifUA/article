class StoriesDecorateInteractor < ApplicationInteractor
  delegate :stories, to: :context
  delegate :group, to: :context

  def call

    if group.blank?
      context.result = stories
      return
    end
    result = []
    current_group_value = ''
    stories.each do |story|
      value = group_value(story)
      if current_group_value != value
        result << Story.new( group: group, group_value: value )
      end
      result << story
      current_group_value = value
    end
    context.result = result
  end


  private

  def group_value(object)
      model = group.start_with?('articles.') ? object.latest_article : object
      model.try(:send, group.split('.').last)
  end
end