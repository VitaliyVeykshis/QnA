require 'rails_helper'

feature 'The user deletes answer', %q{
  As an authenticated user
  As an author
  I'd like to be able to delete the answer
} do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Answer author deletes answer' do
    sign_in_as(user)
    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_current_path(question_path(question))
    expect(page).to have_no_content answer.body
  end

  scenario 'Authenticated user deletes others answer' do
    sign_in_as(second_user)
    visit question_path(question)

    expect(page).to have_no_link 'Delete answer'
  end

  scenario 'Unauthenticated user deletes question' do
    visit question_path(question)

    expect(page).to have_no_link 'Delete answer'
  end
end