class AddPublicationLookupIndexToArticles < ActiveRecord::Migration[8.1]
  def change
    add_index :articles, %i[status published_at], name: "index_articles_on_status_and_published_at"
  end
end
