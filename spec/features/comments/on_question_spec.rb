require 'rails_helper'

feature 'A user comment on question', %q{
  As an authenticated user
  I'd like to be able to comment question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'add comment on question' do
      within '.question' do
        click_on 'add a comment'

        within '.new-comment' do
          fill_in 'Your Comment', with: 'Comment body'
          click_on 'Post Your Comment'
        end

        within '.comments' do
          expect(page).to have_content 'Comment body'
        end
      end
    end

    scenario 'cannot add invalid comment on question' do
      within '.question' do
        click_on 'add a comment'

        within '.new-comment' do
          fill_in 'Your Comment', with: ''
          click_on 'Post Your Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'cannot add comment on question' do
      visit question_path(question)

      expect(page).to have_no_link 'add a comment'
    end
  end
end
