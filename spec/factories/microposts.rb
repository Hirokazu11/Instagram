FactoryBot.define do
  factory :micropost do
    sequence(:title) { |n| "title#{n}" }
    sequence(:content) { |n| "cook#{n}" }
    picture Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/img.png'))
    association :user
  end
end
