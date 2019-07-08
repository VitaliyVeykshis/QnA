require 'rails_helper'

feature 'The user can write the answer to a question', %q{
  On the page of a question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in_as(user)

      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Answer', with: 'Answer body'
      click_on 'Post'

      expect(page).to have_content 'Answer body'
    end

    scenario 'answer the question with errors' do
      click_on 'Post'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer a question with attached files' do
      fill_in 'Answer', with: 'Answer body'

      attach_file 'File', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]
      click_on 'Post'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Post'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end