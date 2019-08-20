require 'rails_helper'

feature 'Search', %(
  In order to search
  I'd like to be able to find
) do
  given(:answer) { create(:answer) }

  describe 'User tries to search', js: true, sphinx: true do
    before do
      visit questions_path
    end

    scenario 'answer by body' do
      fill_in 'Search', with: answer.body
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content "1 result for #{answer.body}"
          expect(page).to have_content answer.question.title
          expect(page).to have_content answer.body
        end
    end
  end
end
