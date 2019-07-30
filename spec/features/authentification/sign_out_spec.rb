require 'rails_helper'

feature 'User can sign out', %q{
  As an authenticated user
  I'd like to be able to sign out
} do
  scenario 'Authenticated user tries to sign out' do
    sign_in_as(create(:user))

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
