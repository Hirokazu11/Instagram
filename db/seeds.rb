User.create!(name:  "Example User",
             user_name: "1",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

31.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               user_name: n,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

#マイクロポスト
users = User.order(:created_at).take(6)
6.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(
                  content: content, 
                  picture: open("#{Rails.root}/test/fixtures/instagram.png")) }
end  

#リレーションシップ
users = User.all
user = users.first
following = users[2..10]
followers = users[3..6]
following.each { |followed|user.follow(followed) }
followers.each { |follower|follower.follow(user) }