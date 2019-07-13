FactoryBot.define do
  factory :badge do
    title { 'MyString' }
    image { fixture_file_upload(Rails.root.join('tmp', 'images', 'badge.png')) }
  end
end
