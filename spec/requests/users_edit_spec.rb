RSpec.describe "プロフィール編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "ログイン後にプロフィール編集をする場合" do
    before do
      login_for_request(user)
      get edit_user_path(user)
    end

    it "正常なレスポンスを返すこと" do
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end

    it "有効なパラメータの場合、更新が成功してユーザーページにリダイレクトすること" do
      patch user_path(user), params: { user: { name: "Update Name",
                                               email: "update@example.com" } }
      expect(response).to redirect_to user
    end
  end

  context "ログインせずにプロフィール編集をする場合" do
    it "編集ページに遷移しようとしたときログイン画面にリダイレクトすること" do
      get edit_user_path(user)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_url
    end

    it "ログイン後に編集ページに遷移すること(フレンドリーフォワーディング)" do
      get edit_user_path(user)
      login_for_request(user)
      expect(response).to redirect_to edit_user_url(user)
    end

    it "更新しようとしたときログイン画面にリダイレクトすること" do
      patch user_path(user), params: { user: { name: "Update Name" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_url
    end
  end

  context "ログイン後に別のユーザーのプロフィール編集をする場合" do
    before do
      login_for_request(other_user)
    end

    it "編集ページに遷移しようとしたときホーム画面にリダイレクトすること" do
      get edit_user_path(user)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_url
    end

    it "更新しようとしたときホーム画面にリダイレクトすること" do
      patch user_path(user), params: { user: { name: "Update Name" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_url
    end
  end
end
