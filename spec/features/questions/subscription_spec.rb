require 'rails_helper'

feature 'Subscription to question', %q(
  In order to subscribe to the question
  As an authenticated user
  Except guests
  I'd like to be able to receive answers to my favorite question
) do
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    context 'when user does not have subscription' do
      before do
        sign_in_as(create(:user))
        visit question_path(question)
      end

      it 'subscribes to question to get updates on new answers' do
        within '.question' do
          click_on 'Subscribe'

          expect(page).not_to have_link 'Subscribe'
          expect(page).to have_link 'Unsubscribe'
        end

        expect(page).to have_content 'You have successfully subscribed.'
      end
    end

    context 'when user have subscription' do
      before do
        sign_in_as(question.user)
        visit question_path(question)
      end

      it 'unsubscribes to question to get updates on new answers' do
        within '.question' do
          click_on 'Unsubscribe'

          expect(page).to have_link 'Subscribe'
          expect(page).not_to have_link 'Unsubscribe'
        end

        expect(page).to have_content 'You have successfully unsubscribed.'
      end
    end
  end

  describe 'Unauthenticated user' do
    it 'does not subscribes to question to get updates on new answers' do
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link 'Subscribe'
        expect(page).not_to have_link 'Unsubscribe'
      end
    end
  end
end
