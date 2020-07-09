User.create!(name: "Example User",
             user_name: "1",
             email: "example@railstutorial.org",
             cooking_history: "ビギナー(0年)",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true)

User.create!(name: "ゲストユーザー",
            user_name: "ゲストユーザー",
            email: "test@example.com",
            cooking_history: "ビギナー(0年)",
            password: "foobar",
            password_confirmation: "foobar")

31.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  cooking_history = ["ビギナー(0年)","ルーキー(1年)","エース(2年)","ベテラン(3年)","マスター(4年以上)"].sample
  password = "password"
  User.create!(name: name,
               user_name: n,
               email: email,
               cooking_history: cooking_history,
               password: password,
               password_confirmation: password)
end

# マイクロポスト
users = User.order(:created_at).take(6)
6.times do |n|
  title = "Cook-No#{n}"
  content = Faker::Lorem.sentence(5)
  users.each do |user|
    user.microposts.create!(
      title: title,
      content: content,
      picture: open("#{Rails.root}/db/fixtures/img.png")
    )
  end
end

# リレーションシップ
users = User.all
user = users.first
following = users[2..20]
followers = users[3..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
