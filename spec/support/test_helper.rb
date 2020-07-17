def login_for_request(user)
  post login_path, params: { session: { email: user.email,
                                        password: user.password } }
end

def login_for_system(user)
  visit login_path
  fill_in "メールアドレス", with: user.email
  fill_in "パスワード", with: user.password
  click_button "ログイン"
end
