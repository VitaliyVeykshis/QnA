require 'rails_helper'

feature 'The user deletes question', %q{
  As an authenticated user
  As an author
  I'd like to be able to delete the question
} do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Question author deletes question' do
    sign_in_as(user)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_current_path(questions_path)
    expect(page).to have_no_content question.title
  end

  scenario 'Authenticated user deletes others question' do
    sign_in_as(second_user)
    visit question_path(question)

    expect(page).to have_no_link 'Delete question'
  end

  scenario 'Unauthenticated user deletes question' do
    visit question_path(question)

    expect(page).to have_no_link 'Delete question'
  end
end