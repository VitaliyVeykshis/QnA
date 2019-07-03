require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to have_no_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: 'New question title'
        fill_in 'Body', with: 'New question body'
        click_on 'Save'

        expect(page).to have_no_content question.title
        expect(page).to have_no_content question.body
        expect(page).to have_content 'New question title'
        expect(page).to have_content 'New question body'
        expect(page).to have_no_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer", js: true do
      visit question_path(create(:question, user: create(:user)))

      within '.question' do
        expect(page).to have_no_link 'Edit'
      end
    end
  end
end
