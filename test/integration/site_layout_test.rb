require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]",root_path
    assert_select "a[href=?]",login_path
    assert_select "a[href=?]",signup_path
    get login_path
    assert_select "title", full_title("ログイン")
    get signup_path
    assert_select "title", full_title("新規登録")
  end
  
  def setup
    @user = users(:michael)
  end
  
  test "layout links when logged in" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]",notifications_path
    assert_select "a[href=?]",users_path
    assert_select "a[href=?]",user_path(@user)
    assert_select "a[href=?]",edit_user_path(@user)
    assert_select "a[href=?]",logout_path
  end    
end
