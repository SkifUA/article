class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :update, :destroy]

  # GET /stories
  def index
    stories = Story.includes(:latest_article).search(search_params)

    decorated_stories = StoriesDecorateInteractor.call(stories: stories, group: search_params[:group] )
    render json: { data: StorySerializer.wrap(decorated_stories.result) }, status: :ok
  end

  # GET /stories/1
  def show
    render json: { data: StorySerializer.new(@story) }, status: :ok
  end

  # POST /stories
  def create
    story = ::Story.new(story_params)

    if story.save
      render json: { data: StorySerializer.new(story) }, status: :created
    else
      render json: { errors: story.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params)
      render json: { data: StorySerializer.new(@story) }, status: :ok
    else
      render json: { errors: story.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /stories/1
  def destroy
    @story.destroy
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def story_params
      params.permit(:name, article_ids: [])
    end

    def search_params
      params.permit(:page, :group, scopes: {}, orders: {})
    end
end
