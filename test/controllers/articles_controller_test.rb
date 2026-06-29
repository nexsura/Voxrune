require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_url

    assert_response :success
    assert_select "h1", "Articles"
    assert_includes response.body, articles(:two).title
    assert_select "time[datetime=?]", articles(:two).published_at.iso8601
    assert_no_match articles(:one).title, response.body
  end
end
