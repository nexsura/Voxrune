class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt
      t.text :body, null: false
      t.integer :status, null: false, default: 0
      t.datetime :published_at

      t.timestamps
    end

    add_index :articles, :slug, unique: true
  end
end
