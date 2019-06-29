require 'rails_helper'

feature 'The user can write the answer to a question', %q{
  On the page of a question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user answer the question' do
    sign_in_as(user)

    visit question_path(question)

    fill_in 'Answer', with: 'Answer body'
    click_on 'Post'

    expect(page).to have_content 'Answer body'
  end

  scenario 'Authenticated user answer the question with errors' do
    sign_in_as(user)

    visit question_path(question)

    click_on 'Post'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Post'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end