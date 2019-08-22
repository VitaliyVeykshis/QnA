require 'rails_helper'

feature 'The user estimates the question', %q{
  As an authenticated user
  Except question author
  I'd like to be able to estimate question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Not author of question', js: true do
    background do
      sign_in_as(create(:user))
      visit question_path(question)
    end

    scenario 'likes question' do
      within '.question' do
        click_on 'like'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_css('.vote-up.active')
      end
    end

    scenario 'dislikes question' do
      within '.question' do
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

  describe 'Author of question' do
    background do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'tries to estimate question' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_no_link 'like'
        expect(page).to have_no_link 'dislike'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to estimate question' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_no_link 'like'
        expect(page).to have_no_link 'dislike'
      end
    end
  end
end
