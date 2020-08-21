class StorySerializer < ::ApplicationSerializer
  attribute :id,              source: :object
  attribute :name,            source: :object
  attribute :created_at,      source: :object
  attribute :updated_at,      source: :object
  attribute :articles_count,  source: :object
  attribute :count_types,     source: :object
  attribute :last_article,    source: :object, with: ArticleSerializer
end