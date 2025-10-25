require "test_helper"

class SavedVideosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get saved_videos_index_url
    assert_response :success
  end

  test "should get create" do
    get saved_videos_create_url
    assert_response :success
  end

  test "should get destroy" do
    get saved_videos_destroy_url
    assert_response :success
  end
end
