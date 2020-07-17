RSpec.describe "ユーザー一覧", type: :request do
  let!(:user) { create(:user) }

  context "ログイン後にユーザー一覧ページに遷移する場合" do
    before do
      login_for_request(user)
      get users_path
    end

    it "正常なレスポンスを返すこと" do
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  context "ログインせずにユーザー一覧ページに遷移する場合" do
    it "ログイン画面にリダイレクトすること" do
      get users_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_url
    end
  end
end
