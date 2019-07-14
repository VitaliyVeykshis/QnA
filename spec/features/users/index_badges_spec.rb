require 'rails_helper'

feature 'The user can look through the badges received by him', %q{
  As an authenticated user
  I'd like to be able to see my badges
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:badge) { create(:badge, question: question, user: user) }

  describe 'Unauthenticated user' do
    scenario 'tries to see badges' do
      visit badges_index_path

      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in_as(user)
      visit badges_index_path
    end

    scenario 'sees his badge' do
      expect(page).to have_content(badge.title)
      expect(page).to have_content(badge.question.title)
      expect(page).to have_css "img[src*='#{badge.image.filename}']"
    end
  end
end