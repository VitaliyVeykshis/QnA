FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment#{n} body" }
    association :user, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
