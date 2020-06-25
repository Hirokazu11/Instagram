require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              user_name: "",
                                              email: "user@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    name = "Foo Bar"
    user_name = "foo"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              user_name: user_name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal user_name, @user.user_name
    assert_equal email, @user.email
  end
end
