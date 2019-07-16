require 'rails_helper'

feature 'The user estimates the answer', %q{
  As an authenticated user
  Except answer author
  I'd like to be able to estimate answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Not author of answer', js: true do
    background do
      sign_in_as(create(:user))
      visit question_path(question)
    end

    scenario 'likes answer' do
      within '.answers' do
        click_on 'Like'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'dislikes answer' do
      within '.answers' do
        click_on 'Dislike'
        expect(page).to have_content 'Rating: -1'
      end
    end
  end

  describe 'Author of answer' do
    background do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'tries to estimate answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to estimate answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end
  end
end
