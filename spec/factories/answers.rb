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

    trait :with_link do
      links { [FactoryBot.build(:link)] }
    end

    trait :with_gist do
      links { [FactoryBot.build(:link, :gist)] }
    end

    trait :with_link_and_gist do
      links do
        [
          FactoryBot.build(:link, :gist),
          FactoryBot.build(:link)
        ]
      end
    end

    factory :answer_with_attachments_link_gist, traits: %i[with_attachments with_link_and_gist]
  end
end
