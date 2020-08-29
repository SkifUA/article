class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    articles = Article.search(search_params)

    render json: { data: ArticleSerializer.wrap(articles, meta: { group: search_params[:group] }) }, status: :ok
  end

  # GET /articles/1
  def show
    render json: { data: ArticleSerializer.new(@article) }, status: :ok
  end

  # POST /articles
  def create
    article = Article.new(article_params)
    if article.save
      ActionCable.server.broadcast('articles', data: ArticleSerializer.new(article))
      head :ok
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
    ActionCable.server.broadcast('delete_article', id: @article.id) if @article.destroy
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def article_params
      params.permit(:name, :text, :article_type)
    end

  def search_params
    params.permit(:page, :group, scopes: {}, orders: {})
  end
end
