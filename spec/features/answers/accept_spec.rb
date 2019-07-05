require 'rails_helper'

feature 'User can accept best answer for his question', %q{
  As an author of question
  I'd like to be able to accept best answer for my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'accept answer' do
      sign_in_as(user)
      visit question_path(question)

      within "#answer-#{answers[1].id}" do
        click_on 'Best'
      end

      within '.accepted-answer' do
        expect(page).to have_content answers[1].body
        expect(page).to have_no_link 'Best'
      end

      within all('.sugested-answer')[0] do
        expect(page).to have_no_content answers[1].body
      end

      within all('.sugested-answer')[1] do
        expect(page).to have_no_content answers[1].body
      end
    end

    scenario "tries to set up best answer for other's user question" do
      sign_in_as(create(:user))
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_link 'Best'
      end
    end
  end

  scenario 'Unauthenticated user can not set up best answer', js: true do
    visit question_path(question)

    expect(page).to have_no_link 'Best'
  end
end