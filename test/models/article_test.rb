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
end
