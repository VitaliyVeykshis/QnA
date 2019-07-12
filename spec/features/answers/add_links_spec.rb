require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/VitaliyVeykshis/bba333f611c70a24cd9a2364e43ce738' }
  given(:second_url) { 'https://thinknetica.com' }

  scenario 'User adds links when asks answer', js: true do
    sign_in_as(user)
    visit question_path(question)

    fill_in 'Answer', with: 'Answer body'

    click_on 'Add link'

    within all('.nested-fields')[0] do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Add link'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'Thinknetica'
      fill_in 'Url', with: second_url
    end

    click_on 'Post'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Thinknetica', href: second_url
    end
  end
end
