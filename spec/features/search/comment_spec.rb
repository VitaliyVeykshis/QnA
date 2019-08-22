require 'rails_helper'

feature 'Search', %(
  In order to search
  I'd like to be able to find
) do
  given(:comment) { create(:comment) }

  describe 'User tries to search', js: true, sphinx: true do
    before do
      visit questions_path
    end

    scenario 'comment by body' do
      fill_in 'Search', with: comment.body
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content "1 result for #{comment.body}"
          expect(page).to have_content comment.commentable.title
          expect(page).to have_content comment.body
        end
    end
  end
end
