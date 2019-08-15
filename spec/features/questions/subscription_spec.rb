require 'rails_helper'

feature 'Subscription to question', %q(
  In order to subscribe to the question
  As an authenticated user
  Except guests
  I'd like to be able to receive answers to my favorite question
) do
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    before do
      sign_in_as(create(:user))
      visit question_path(question)
    end

    it 'subscribes to new answer notify' do
      within '.question' do
        click_on 'Subscribe'

        expect(page).not_to have_link 'Subscribe'
      end

      expect(page).to have_content 'You have successfully subscribed.'
    end
  end

  describe 'Unauthenticated user' do
    it 'does not subscribes to new answer notify' do
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link 'Subscribe'
      end
    end
  end
end
