require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "valid fixture article" do
    assert articles(:one).valid?
  end

  test "requires title" do
    article = articles(:one)
    article.title = nil

    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
  end

  test "requires unique slug" do
    article = Article.new(
      title: "Another article",
      slug: articles(:one).slug,
      body: "Another article body",
      status: :draft
    )

    assert_not article.valid?
    assert_includes article.errors[:slug], "has already been taken"
  end

  test "defaults to draft status" do
    article = Article.new(
      title: "Draft article",
      slug: "draft-article",
      body: "Draft article body"
    )

    assert article.draft?
  end

  test "published_recent_first returns published articles with a publication date" do
    assert_equal [ articles(:two) ], Article.published_recent_first.to_a
  end

  test "requires URL friendly slug" do
    article = Article.new(
      title: "Invalid slug article",
      slug: "Invalid Slug!",
      body: "Invalid slug body",
      status: :draft
    )

    assert_not article.valid?
    assert_includes article.errors[:slug], "must use lowercase letters, numbers, and hyphens"
  end

  test "published article requires published_at" do
    article = Article.new(
      title: "Published without date",
      slug: "published-without-date",
      body: "Published article body",
      status: :published
    )

    assert_not article.valid?
    assert_includes article.errors[:published_at], "must be set when article is published"
  end
end
