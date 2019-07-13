FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'http://www.google.com' }

    trait :gist do
      url { 'https://gist.github.com/VitaliyVeykshis/bba333f611c70a24cd9a2364e43ce738' }
    end
  end
end
