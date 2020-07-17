require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  it "名前,メール ,パスワードがあれば有効な状態であること" do
    expect(user).to be_valid
  end

  it "名前がなければ無効な状態であること" do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "名前の字数が50文字を越えた場合は無効な状態であること" do
    user = build(:user, name: "a" * 51)
    user.valid?
    expect(user.errors[:name]).to include("は50文字以内で入力してください")
  end

  it "メールがなければ無効な状態であること" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "メールの字数が255文字を越えた場合は無効な状態であること" do
    user = build(:user, email: "#{"a" * 244}@example.com")
    user.valid?
    expect(user.errors[:email]).to include("は255文字以内で入力してください")
  end

  it "小文字大文字の区別なく、重複したメールアドレスなら無効な状態であること" do
    other_user = build(:user, email: user.email)
    other_user.valid?
    expect(other_user.errors[:email]).to include("はすでに存在します")
  end

  it "メールアドレスが小文字で保存されること" do
    user = create(:user, email: "EXAMPLE@example.com")
    expect(user.email).to eq "example@example.com"
  end

  it "パスワードがなければ無効な状態であること" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "パスワードの字数が5文字以下の場合は無効な状態であること" do
    user = build(:user, password: "a" * 5)
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end

  it "ダイジェストが存在しない場合、falseを返すこと" do
    expect(user.authenticated?('')).to eq false
  end
end
