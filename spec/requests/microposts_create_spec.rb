require "rails_helper"

RSpec.describe "新規投稿", type: :request do
  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost) }

  context "ログインしている場合" do
    before do
      login_for_request(user)
    end

    it "有効な投稿の場合、登録が成功してユーザーページにリダイレクトすること" do
      expect do
        post microposts_path, params: { micropost: FactoryBot.attributes_for(:micropost) }
      end.to change(Micropost, :count).by(1)
      expect(response).to redirect_to user_url(user)
    end

    it "無効な投稿の場合、登録ができないこと" do
      expect do
        post microposts_path, params: { micropost: { content: "" } }
      end.not_to change(Micropost, :count)
    end
  end

  context "ログインしていない場合" do
    it "ログインページへリダイレクトすること" do
      expect do
        post microposts_path, params: { micropost: FactoryBot.attributes_for(:micropost) }
      end.not_to change(Micropost, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
