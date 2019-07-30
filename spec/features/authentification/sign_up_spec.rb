require 'rails_helper'

feature 'User can sign up', %q{
  I'd like to be able to sign up
} do
  background { visit new_user_registration_path }

  scenario 'Unregistred user tries to sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    within '.new_user' do
      click_on 'Sign up'
    end

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'

    open_email('user@test.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content('Your email address has been successfully confirmed.')
  end

  describe 'OAuth authentication' do
    scenario 'Sign up with GitHub' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from GitHub account.')
    end

    scenario 'Sign up with VKontakte' do
      click_on 'Sign in with Vkontakte'

      within 'form' do
        fill_in 'Email', with: 'user@test.com'
        click_on 'Sign up'
      end

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end
  end
end
