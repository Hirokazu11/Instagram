FactoryBot.define do
  factory :micropost do
    sequence(:content) { |n| "cook#{n}" }

    association :user
  end
end
