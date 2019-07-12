require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/VitaliyVeykshis/bba333f611c70a24cd9a2364e43ce738' }
  given(:second_url) { 'https://thinknetica.com' }

  scenario 'User adds links when asks question', js: true do
    sign_in_as(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

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

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Thinknetica', href: second_url
  end
end