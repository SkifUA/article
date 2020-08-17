class StorySerializer < ::ApplicationSerializer
  attribute :id,                    source: :object
  attribute :name,                  source: :object
  attribute :created_at,            source: :object
  attribute :updated_at,            source: :object
  attribute :articles_count,        source: :object
  attribute :count_types,           source: :object
  attribute :last_created_article,  with: ArticleSerializer

  def last_created_article
    object.last_created_article&.article
  end
end