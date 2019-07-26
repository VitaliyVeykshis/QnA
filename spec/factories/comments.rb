FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment#{n} body" }

    trait :invalid do
      body { nil }
    end
  end
end
