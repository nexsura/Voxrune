require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_url

    assert_response :success
    assert_select "h1", "Articles"
    assert_includes response.body, articles(:two).title
    assert_select "a[href=?]", article_path(articles(:two)), articles(:two).title
    assert_select "time[datetime=?]", articles(:two).published_at.iso8601
    assert_no_match articles(:one).title, response.body
  end

  test "should show published article" do
    get article_url(articles(:two))

    assert_response :success
    assert_select "h1", articles(:two).title
    assert_select "a[href=?]", articles_path, "Back to articles"
    assert_select "time[datetime=?]", articles(:two).published_at.iso8601
    assert_includes response.body, articles(:two).body
  end

  test "should not show draft article" do
    get article_url(articles(:one))

    assert_response :not_found
  end

  test "should not show unknown article" do
    get article_url("unknown-article")

    assert_response :not_found
  end
end
