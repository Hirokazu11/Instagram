require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "create should require logged-in user" do
    assert_no_difference 'Like.count' do
      post likes_path
    end
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Like.count' do
      delete like_path(likes(:one))
    end
  end
end
