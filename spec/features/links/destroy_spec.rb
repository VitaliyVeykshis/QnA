require 'rails_helper'

feature 'User deletes a link', %q{
  As an authenticated user
  As an author
  I'd like to be able to delete the link
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:question_link) { create(:link, linkable: question) }
  given!(:answer_link) { create(:link, linkable: answer) }

  describe 'Author', js: true do
    background do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'deletes link from question' do
      within '.question .links' do
        click_on 'Remove'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_no_link question_link.name, href: question_link.url
      end
    end

    scenario 'deletes link from answer' do
      within "#answer-#{answer.id} .links" do
        click_on 'Remove'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_no_link question_link.name, href: question_link.url
      end
    end
  end

  describe 'Not author', js: true do
    background do
      sign_in_as(create(:user))
      visit question_path(question)
    end

    scenario 'can not delete link from question' do
      within '.question .links' do
        expect(page).to have_no_link 'Remove'
      end
    end

    scenario 'can not delete link from answer' do
      within "#answer-#{answer.id} .links" do
        expect(page).to have_no_link 'Remove'
      end
    end
  end
end
