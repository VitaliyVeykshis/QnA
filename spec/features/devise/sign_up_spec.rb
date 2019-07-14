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

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
