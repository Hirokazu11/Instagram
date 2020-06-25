User.create!(name: "Example User",
             user_name: "1",
             email: "example@railstutorial.org",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true)

31.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               user_name: n,
               email: email,
               password: password,
               password_confirmation: password)
end

# マイクロポスト
users = User.order(:created_at).take(6)
6.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user|
    user.microposts.create!(
      content: content,
      picture: open("#{Rails.root}/test/fixtures/instagram.png")
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
