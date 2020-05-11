require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:archer)
    log_in_as(@user)
    @micropost = microposts(:orange)
  end

  test "create comment and delete comment" do
    assert_difference '@micropost.comments.count',1 do
      post micropost_comments_path(@micropost), params:{ comment: {content: "Comment test" }}
    end
    comment = @micropost.comments.find_by(content: "Comment test")
    assert_difference '@micropost.comments.count',-1 do
      delete micropost_comment_path(@micropost, comment)
    end      
  end  
  
end
