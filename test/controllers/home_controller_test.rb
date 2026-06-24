require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
    assert_select "h1", "NexsNews"
    assert_select "p", "A technical news and publishing platform built with Ruby on Rails."
    assert_select "p", "The application is running successfully."
  end
end
