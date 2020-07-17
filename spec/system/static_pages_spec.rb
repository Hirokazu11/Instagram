require 'rails_helper'

RSpec.describe "StaticPages", type: :system, js: true do
  describe "トップページ" do
    before do
      visit root_path
    end

    it "正しいタイトルが表示されること" do
      expect(page).to have_title "CookGrowth"
    end

    context "ログインしている場合" do
      let!(:user) { create(:user) }
      let!(:micropost) { create(:micropost) }

      before do
        login_for_system(user)
      end

      it "投稿のぺージネーションが表示されること" do
        create_list(:micropost, 31, user: user)
        visit root_path
        page.has_content?("Cook Growth")
        page.has_css?("div.pagination", text: 2)
        Micropost.take(30).each do |d|
          page.has_content?(d.content)
        end
      end
    end
  end
end
