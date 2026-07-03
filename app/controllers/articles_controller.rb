class ArticlesController < ApplicationController
  def index
    @articles = Article.published_recent_first
  end

  def show
    @article = Article.published.find_by!(slug: params[:id])
  end
end
