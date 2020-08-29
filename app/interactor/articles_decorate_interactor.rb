class ArticlesDecorateInteractor < ApplicationInteractor
  delegate :articles, to: :context
  delegate :group, to: :context

  def call
    if group.blank?
      context.result = articles
      return
    end
    result = []
    current_group_value = ''
    articles.each do |article|
      value = group_value(article)
      if current_group_value != value
        result << Article.new( group: group, group_value: value )
      end
      result << article
      current_group_value = value
    end

    context.result = result
  end

  private

  def group_value(object)
    object.try(:send, group)
  end
end