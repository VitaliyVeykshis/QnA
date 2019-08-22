require 'rails_helper'

feature 'Search', %(
  In order to search
  I'd like to be able to find
) do
  given(:question) { create(:question) }

  describe 'User tries to search', js: true, sphinx: true do
    before do
      visit questions_path
    end

    scenario 'question by title' do
      fill_in 'Search', with: question.title
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content "1 result for #{question.title}"
          expect(page).to have_content question.title
          expect(page).to have_content question.body
        end
    end

    scenario 'question by body' do
      fill_in 'Search', with: question.body
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content "1 result for #{question.body}"
          expect(page).to have_content question.title
          expect(page).to have_content question.body
        end
    end
  end
end
