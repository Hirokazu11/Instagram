require 'rails_helper'

RSpec.describe "ユーザー削除", type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_user) { create(:user) }

  context "管理者の場合" do
    it "ユーザー削除が成功しユーザー一覧ページにリダイレクトすること" do
      login_for_request(admin_user)
      expect do
        delete user_path(other_user)
      end.to change(User, :count).by(-1)
      expect(response).to redirect_to users_url
    end
  end

  context "ログインしていない場合" do
    it "削除に失敗してログインページにリダイレクトすること" do
      expect do
        delete user_path(other_user)
      end.not_to change(User, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_url
    end
  end
end
