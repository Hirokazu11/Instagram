require 'rails_helper'

RSpec.describe "ログイン", type: :request do
  let(:user) { create(:user) }

  context "「ログインしたままにする」にチェックを入れてログインする場合" do
    it "remember_tokenが空でないこと" do
      post login_path, params: { session: { email: user.email,
                                            password: user.password,
                                            remember_me: '1' } }
      expect(response.cookies['remember_token']).not_to eq nil
    end
  end

  context "「ログインしたままにする」にチェックを入れずにログインする場合" do
    it "remember_tokenが空であること" do
      post login_path, params: { session: { email: user.email,
                                            password: user.password,
                                            remember_me: '0' } }
      expect(response.cookies['remember_token']).to eq nil
    end
  end

  it "ログイン中のみログアウトすること" do
    login_for_request(user)
    expect(response).to redirect_to user

    # ログアウトする
    delete logout_path
    expect(response).to redirect_to root_path
    expect(session[:user_id]).to eq nil

    # ２番めのウィンドウでログアウトする
    delete logout_path
    expect(response).to redirect_to root_path
    expect(session[:user_id]).to eq nil
  end
end
