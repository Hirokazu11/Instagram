require 'rails_helper'

RSpec.describe "StaticPages", type: :system, js: true do
  describe "トップページ" do
    before do
      visit root_path
    end

    it "正しいタイトルが表示されること" do
      expect(page).to have_title "CookGrowth"
    end

end
