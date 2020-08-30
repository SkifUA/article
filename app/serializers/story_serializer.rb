class StorySerializer < ::ApplicationSerializer
  attribute :id,              source: :object
  attribute :name,            source: :object
  attribute :created_at,      source: :object
  attribute :updated_at,      source: :object
  attribute :articles_count,  source: :object
  attribute :types_count,     source: :object
  attribute :last_article,    source: :object, field: :latest_article, with: ArticleSerializer
  attribute :group,           source: :object
  attribute :group_value,     source: :object
end