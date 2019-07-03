require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Edit'
  end

  describe 'Authenticated user' do
    background { sign_in_as(user) }

    scenario 'edits his answer', js: true do
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'answer_body', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_no_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'answer_body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer", js: true do
      question = create(:question, user: user)
      create(:answer, user: create(:user), question: question)

      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_link 'Edit'
      end
    end
  end
end
