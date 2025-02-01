require "flickr"
class ArticlesController < ApplicationController
  before_action :set_flickr, only: [ :images ]
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end
  def images
    # use flickr api to get images
    @images=nil
    return unless params[:user_id].present?
    @images=@flickr.people.getPhotos(user_id: params[:user_id]).map do |hash|
      "https://live.staticflickr.com/#{hash["server"]}/#{hash["id"]}_#{hash["secret"]}_c.jpg"
    end
    Rails.logger.info @images
  end
  private
    def article_params
      params.expect(article: [ :title, :body ])
    end
    def set_flickr
      @flickr = Flickr.new(ENV["key"], ENV["secret"])
    end
end
