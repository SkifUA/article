class ArticleSerializer < ::ApplicationSerializer
  attribute :id,                  source: :object
  attribute :name,                source: :object
  attribute :text,                source: :object
  attribute :article_type,        source: :object
  attribute :created_at,          source: :object
  attribute :updated_at,          source: :object
  attribute :group,               source: :object
  attribute :group_value,         source: :object
end