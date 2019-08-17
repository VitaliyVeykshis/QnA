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
  given(:invalid_gist_url) { 'gist.github.com/VitaliyVeykshis/bba333f611c70a24cd9a2364e43ce738' }

  background do
    sign_in_as(user)
    visit question_path(question)

    fill_in 'Answer', with: 'Answer body'
    click_on 'Add link'
  end

  scenario 'User adds valid links when answer', js: true do
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

    wait_for_ajax

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Thinknetica', href: second_url
    end
  end

  scenario 'User try to add invalid link when answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: invalid_gist_url

    click_on 'Post'

    expect(page).to have_no_link 'My gist', href: invalid_gist_url
    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'User adds gist link when answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Post'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_content 'gist text'
  end
end
