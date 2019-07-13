require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/VitaliyVeykshis/bba333f611c70a24cd9a2364e43ce738' }
  given(:second_url) { 'https://thinknetica.com' }
  given(:invalid_gist_url) { 'gist.github.com/VitaliyVeykshis/bba333f611c70a24cd9a2364e43ce738' }

  background do
    sign_in_as(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    click_on 'Add link'
  end

  scenario 'User adds links when asks question', js: true do
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

  scenario 'User try to add invalid link when asks question', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: invalid_gist_url

    click_on 'Ask'

    expect(page).to have_no_link 'My gist', href: invalid_gist_url
    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'User adds gist link when asks question', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_content 'gist text'
  end
end