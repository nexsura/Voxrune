class ArticlesController < ApplicationController
  def index
    @articles = Article.published_recent_first
  end

  def show
    @article = Article.publicly_visible.find_by!(slug: params[:id])
  end
end
