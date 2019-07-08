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

    trait :with_attachments do
      files do
        [
          fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb')),
          fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'))
        ]
      end
    end
  end
end
