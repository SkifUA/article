class StorySerializer < ::ApplicationSerializer
  attribute :id,              source: :object
  attribute :name,            source: :object
  attribute :created_at,      source: :object
  attribute :updated_at,      source: :object
  attribute :articles_count,  source: :object
  attribute :types_count,     source: :object
  attribute :last_article,    source: :object, with: ->(m) { ArticleSerializer.new(m.first) }
  attribute :group
  attribute :group_value

  def group
    meta[:group]
  end

  def group_value
    if meta[:group].present?
      model = meta[:group].start_with?('article.') ? object.last_article.first : object
      field = meta[:group].start_with?('article.') ? meta[:group].sub('article.') : meta[:group]
      model.try(:set, field)
    end
  end
end