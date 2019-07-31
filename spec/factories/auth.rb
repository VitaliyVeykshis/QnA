FactoryBot.define do
  factory :auth, class: OmniAuth::AuthHash do
    sequence(:uid, &:to_s)

    trait :github do
      provider { 'github' }
      info { { email: 'user@mail.com' } }
    end

    trait :vkontakte do
      provider { 'vkontakte' }
    end
  end
end
