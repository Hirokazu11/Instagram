require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @micropost = microposts(:orange)
    @comment = comments(:one)
    @other_user = users(:malory)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post micropost_comments_path(@micropost), params:{ comment: {content: "Comment test" }}
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete micropost_comment_path(@micropost, @comment)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as other_user" do
    log_in_as(@other_user)
    assert_no_difference 'Comment.count' do
      delete micropost_comment_path(@micropost, @comment)
    end
    assert_redirected_to root_url
  end
  
  
end
