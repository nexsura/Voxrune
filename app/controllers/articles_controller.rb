class ArticlesController < ApplicationController
  def index
    @articles = Article.published_recent_first
  end
end
