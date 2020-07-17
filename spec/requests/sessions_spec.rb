require 'rails_helper'

RSpec.describe "ログイン", type: :request do
  let(:user) { create(:user) }

  it "正常なレスポンスを返すこと" do
    get login_path
    expect(response).to be_successful
    expect(response).to have_http_status(200)
  end

  it "有効なユーザーの場合、ログインが成功してユーザーページにリダイレクトすること" do
    login_for_request(user)
    expect(response).to redirect_to user
  end

  it "ログアウトするとホームページにリダイレクトすること" do
    login_for_request(user)
    delete logout_path
    expect(response).to redirect_to root_path
    expect(session[:user_id]).to eq nil
  end
end
