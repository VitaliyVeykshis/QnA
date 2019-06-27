require 'rails_helper'

feature 'The user can look through the list of questions', %q{
  I'd like to be able to view questions list
} do
  scenario 'The user sees questions list' do
    questions = create_list(:question, 2)

    visit questions_path

    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.last.title)
  end
end
