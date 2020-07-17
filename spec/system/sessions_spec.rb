RSpec.describe "Sessions", type: :system, js: true do
  let!(:user) { create(:user) }

  describe "ユーザーログインページ" do
    before do
      visit login_path
    end

    it "正しいタイトルが表示されること" do
      expect(page).to have_title "ログイン - CookGrowth"
    end

    it "ログインに成功するとその前後でヘッダーが正しく表示されること" do
      expect(page).to have_link "ログイン"
      expect(page).not_to have_link "ログアウト"

      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"

      expect(page).to have_link "通知"
      expect(page).to have_link "ジストモを探す"
      expect(page).to have_link "ジストモ交流会"
      expect(page).to have_content "アカウント"
      click_on "アカウント"
      expect(page).to have_link "プロフィール"
      page.has_link?("設定変更")
      page.has_link?("ログアウト")
      expect(page).not_to have_link "ログイン"
    end

    it "無効なユーザーでログインを行うとログイン失敗のエラーが表示されること" do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "foo"
      click_button "ログイン"
      page.has_content?("メールアドレスもしくはパスワードが無効です")
    end
  end
end
