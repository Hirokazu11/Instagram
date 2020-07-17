require 'rails_helper'

RSpec.describe "Users", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    it "正しいタイトルが表示されること" do
      expect(page).to have_title "ユーザー登録 - CookGrowth"
    end

    it "ユーザー登録することができる" do
      fill_in "名前", with: "Example User"
      fill_in "ユーザーネーム", with: "Exam User"
      fill_in "メールアドレス", with: "exam@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認）", with: "password"
      expect do
        click_button "登録"
      end.to change(User, :count).by(1)
      expect(page).to have_content "登録完了"
    end

    it "無効なユーザーで登録を行うと登録失敗のエラーが表示されること" do
      fill_in "名前", with: ""
      fill_in "ユーザーネーム", with: "Exam User"
      fill_in "メールアドレス", with: "exam@examplecom"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認）", with: "pass"
      expect do
        click_button "登録"
        expect(page).to have_content "Nameを入力してください"
        expect(page).to have_content "Emailは不正な値です"
        expect(page).to have_content "Password confirmationとPasswordの入力が一致しません"
      end.not_to change(User, :count)
    end
  end

  describe "ユーザー設定変更ページ" do
    before do
      login_for_system(user)
      click_on "アカウント"
      visit edit_user_path(user)
    end

    it "有効なパラメータの場合、ユーザー更新ができる" do
      # 正しいタイトルが表示されること
      expect(page).to have_title "設定変更 - CookGrowth"
      # ユーザー更新ができること
      fill_in "名前", with: "Update User"
      fill_in "メールアドレス", with: "update@example.com"
      click_button "変更"
      expect(page).to have_content "プロフィールを更新しました"
      expect(user.reload.name).to eq "Update User"
      expect(user.reload.email).to eq "update@example.com"
    end

    it "無効なパラメータの場合、ユーザー更新ができない" do
      fill_in "名前", with: ""
      fill_in "メールアドレス", with: ""
      click_button "変更"
      expect(page).to have_content "Nameを入力してください"
      expect(page).to have_content "Emailを入力してください"
      expect(page).to have_content "Emailは不正な値です"
      expect(user.reload.name).not_to eq ""
      expect(user.reload.email).not_to eq ""
    end
  end

  describe "ジストモを探すページ" do
    it "ページネーションでユーザー一覧が正しく表示されること" do
      create_list(:user, 31)
      login_for_system(user)
      visit users_path
      expect(page).to have_title "ジストモを探す - CookGrowth"
      expect(page).to have_css("div.pagination", text: 2)
      User.paginate(page: 1).each do |user|
        expect(page).to have_css("li", text: user.name)
        expect(page).not_to have_link("削除", href: user_path(user))
      end
    end

    it "管理者でログインした場合" do
      login_for_system(admin_user)
      visit users_path
      # 他のユーザーを削除できること
      page.has_link?("削除", href: user_path(User.first))
      expect do
        click_on("削除", match: :first)
        page.driver.browser.switch_to.alert.accept
        page.has_content?("ユーザーを削除しました")
      end.to change(User, :count).by(-1)
      # 自分自身の削除リンクは表示されないこと
      page.has_no_link?("削除", href: user_path(admin_user))
    end
  end
end
