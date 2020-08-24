class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    articles = Article.search(search_params)

    render json: { data: ArticleSerializer.wrap(articles) }, status: :ok
  end

  # GET /articles/1
  def show
    render json: { data: ArticleSerializer.new(@article) }, status: :ok
  end

  # POST /articles
  def create
    article = Article.new(article_params)

    if article.save
      render json: { data: ArticleSerializer.new(article) }, status: :created
    else
      render json: { errors: article.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: { data: ArticleSerializer.new(@article) }, status: :ok
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def article_params
      params.permit(:name, :text, :article_type, story_ids: [])
    end

  def search_params
    params.permit(:page, scopes: {}, orders: {}, q: {})
  end
end
