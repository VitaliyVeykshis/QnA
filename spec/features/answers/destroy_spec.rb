require 'rails_helper'

feature 'The user deletes answer', %q{
  As an authenticated user
  As an author
  I'd like to be able to delete the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background { sign_in_as(user) }

    scenario 'deletes his answer' do
      visit question_path(question)

      click_on 'Delete answer'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_current_path(question_path(question))
      expect(page).to have_no_content answer.body
    end

    scenario "deletes other user's answer" do
      visit question_path(create(:question, user: create(:user)))

      expect(page).to have_no_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user deletes answer', js: true do
    visit question_path(question)

    expect(page).to have_no_link 'Delete answer'
  end
end
