require "rails_helper"

RSpec.describe "投稿の削除", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }

  context "ログインしている場合" do
    it "自分の投稿削除が成功し、トップページにリダイレクトすること" do
      login_for_request(user)
      expect do
        delete micropost_path(micropost)
      end.to change(Micropost, :count).by(-1)
      redirect_to user_path(user)
      expect(response).to redirect_to root_url
    end

    it "他人の投稿削除が失敗し、トップページへリダイレクトすること" do
      login_for_request(other_user)
      expect do
        delete micropost_path(micropost)
      end.not_to change(Micropost, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_url
    end
  end

  context "ログインしていない場合" do
    it "ログインページへリダイレクトすること" do
      expect do
        delete micropost_path(micropost)
      end.not_to change(Micropost, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
