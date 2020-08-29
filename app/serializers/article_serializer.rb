class ArticleSerializer < ::ApplicationSerializer
  attribute :id,                  source: :object
  attribute :name,                source: :object
  attribute :text,                source: :object
  attribute :article_type,        source: :object
  attribute :created_at,          source: :object
  attribute :updated_at,          source: :object
  attribute :group
  attribute :group_value

  def group
    meta[:group]
  end

  def group_value
    object.try(:set, meta[:group]) if meta[:group].present?
  end
end