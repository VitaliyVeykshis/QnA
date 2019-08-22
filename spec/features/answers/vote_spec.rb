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
        click_on 'like'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_css('.vote-up.active')
      end
    end

    scenario 'dislikes answer' do
      within '.answers' do
        click_on 'dislike'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_css('.vote-down.active')
      end
    end

    scenario 'cancel the decision' do
      within '.question' do
        click_on 'like'
        click_on 'like'
        sleep 1
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_no_css('.vote-up.active')
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
        expect(page).to have_no_link 'like'
        expect(page).to have_no_link 'dislike'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to estimate answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_link 'like'
        expect(page).to have_no_link 'dislike'
      end
    end
  end
end
