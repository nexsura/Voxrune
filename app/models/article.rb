class Article < ApplicationRecord
  SLUG_FORMAT = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

  enum :status, {
    draft: 0,
    published: 1,
    archived: 2
  }

  before_validation :set_slug, if: -> { slug.blank? && title.present? }
  scope :recent_first, -> { order(published_at: :desc, created_at: :desc) }
  scope :published_recent_first, -> { published.where.not(published_at: nil).recent_first }

  validates :title, presence: true
  validates :slug,
    presence: true,
    uniqueness: true,
    format: {
      with: SLUG_FORMAT,
      message: "must use lowercase letters, numbers, and hyphens"
    }
  validates :body, presence: true
  validates :status, presence: true
  validate :published_article_has_published_at

  def to_param
    slug
  end

  private

  def published_article_has_published_at
    return unless published? && published_at.blank?

    errors.add(:published_at, "must be set when article is published")
  end

  def set_slug
    self.slug = title.parameterize
  end
end
