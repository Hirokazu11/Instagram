FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test_name#{n}" }
    sequence(:user_name) { |n| "name#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }

    trait :admin do
      admin { true }
    end
  end
end
