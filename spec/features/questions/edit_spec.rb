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

  describe 'Authenticated user', js: true do
    background do
      sign_in_as(user)

      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edits his question' do
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

    scenario 'edits his question with errors' do
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

    scenario "tries to edit other user's answer" do
      visit question_path(create(:question, user: create(:user)))

      within '.question' do
        expect(page).to have_no_link 'Edit'
      end
    end

    scenario 'during editing of a question can attach files' do
      within '.question' do
        fill_in 'Title', with: 'New question title'
        fill_in 'Body', with: 'New question body'
        attach_file 'File', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
