require 'rails_helper'

feature 'The user estimates the question', %q{
  As an authenticated user
  I'd like to be able to estimate question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'likes question' do
      within '.question' do
        click_on 'Like'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'dislikes question' do
      within '.question' do
        click_on 'Dislike'
        expect(page).to have_content 'Rating: -1'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to estimate question' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end
  end
end
