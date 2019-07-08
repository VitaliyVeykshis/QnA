FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer#{n} body" }

    trait :invalid do
      body { nil }
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
