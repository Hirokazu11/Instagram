require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  def setup
    @comment = Comment.new(content: "test comment",user_id: users(:michael).id,
              micropost_id: microposts(:ants).id)
  end
  
  test "should be valid" do
    assert @comment.valid?
  end
  
  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end
  
  test "content should be present" do
    @comment.micropost_id = nil
    assert_not @comment.valid?
  end  
  
  test "content should be at most 255 characters" do
    @comment.content = "a"*256
    assert_not @comment.valid?
  end  
  
end
