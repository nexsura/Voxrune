class Article < ApplicationRecord
  enum :status, {
    draft: 0,
    published: 1,
    archived: 2
  }

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true
  validates :status, presence: true
end
