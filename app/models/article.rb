class Article < ApplicationRecord
  enum :status, {
    draft: 0,
    published: 1,
    archived: 2
  }
  scope :recent_first, -> { order(published_at: :desc, created_at: :desc) }
  scope :published_recent_first, -> { published.where.not(published_at: nil).recent_first }
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true
  validates :status, presence: true
end
