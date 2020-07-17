require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:micropost) { create(:micropost) }
  let!(:micropost_yesterday) { create(:micropost) }
  let!(:micropost_now) { create(:micropost) }

  it "有効な状態であること" do
    expect(micropost).to be_valid
  end

  it "user_idがなければ無効な状態であること" do
    micropost = build(:micropost, user_id: nil)
    expect(micropost).not_to be_valid
    expect(micropost.errors[:user_id]).to include("を入力してください")
  end

  it "投稿の字数が140文字を越えた場合は無効な状態であること" do
    micropost = build(:micropost, content: "a" * 141)
    micropost.valid?
    expect(micropost.errors[:content]).to include("は140文字以内で入力してください")
  end

  it "最も最近の投稿が最初の投稿になっていること" do
    expect(micropost_now).to eq Micropost.first
  end
end
