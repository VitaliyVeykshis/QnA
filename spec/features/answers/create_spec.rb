require 'rails_helper'

feature 'The user can write the answer to a question', %q{
  On the page of a question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'The user answer the question' do
    visit question_path(question)

    fill_in 'Answer', with: answer.body
    click_on 'Post'

    expect(page).to have_content answer.body
  end
end