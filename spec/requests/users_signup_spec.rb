require 'rails_helper'

RSpec.describe "ユーザー登録", type: :request do
  before do
    get signup_path
  end

  it "正常なレスポンスを返すこと" do
    expect(response).to be_successful
    expect(response).to have_http_status(200)
  end

  it "有効なユーザーの場合、登録が成功してユーザーページにリダイレクトすること" do
    expect do
      post users_path, params: { user: FactoryBot.attributes_for(:user) }
    end.to change(User, :count).by(1)
    expect(response).to redirect_to User.last
  end

  it "無効なユーザーの場合、登録ができないこと" do
    expect do
      post users_path, params: { user: FactoryBot.attributes_for(:user, name: "") }
    end.not_to change(User, :count)
  end
end
