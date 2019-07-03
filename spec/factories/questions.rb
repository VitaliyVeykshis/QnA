FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question#{n} title" }
    sequence(:body) { |n| "Question#{n} body" }

    trait :invalid do
      title { nil }
    end

    trait :new do
      title { 'New title' }
      body { 'New body' }
    end
  end
end
