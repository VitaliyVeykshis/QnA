require 'rails_helper'

feature 'User can delete attachments from his question', %q{
  In order to correct mistakes
  As an authenticated user
  As an author of answer
  I'd like to be able to delete attachments from my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_attachments, user: user) }

  describe 'Question author', js: true do
    background do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'deletes attachment from his question' do
      within "#attachment-#{question.files[0].id}" do
        click_on 'Delete'
        page.driver.browser.switch_to.alert.accept
      end

      within '.attachments' do
        expect(page).to have_no_link question.files[0].filename.to_s
      end
    end
  end

  describe 'Not author', js: true do
    background do
      sign_in_as(create(:user))
      visit question_path(question)
    end

    scenario 'tries to delete attachment from question' do
      within '.attachments' do
        expect(page).to have_no_link 'Delete'
      end
    end
  end
end