require 'rails_helper'

feature 'Search', %(
  In order to search
  I'd like to be able to find
) do
  given(:user) { create(:user) }

  describe 'User tries to search', js: true, sphinx: true do
    before do
      visit questions_path
    end

    scenario 'user by email' do
      fill_in 'Search', with: user.email
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content "1 result for #{user.email}"
          expect(page).to have_content user.email
        end
    end
  end
end
