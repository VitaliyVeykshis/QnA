require 'rails_helper'

feature 'The user sees specific question', %q{
  As an authenticated user
  As an unauthenticated user
  I'd like to be able to view specific question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Authenticated user sees specific question with answers' do
    sign_in_as(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end

  scenario 'Unauthenticated user sees specific question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end
end