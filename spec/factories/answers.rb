FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer#{n} body" }

    trait :invalid do
      body { nil }
    end
  end
end
