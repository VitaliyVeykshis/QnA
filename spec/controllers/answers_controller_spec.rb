require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        }.not_to change(Answer, :count)
      end

      it 'renders question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template 'questions/show'
      end
    end
  end
end
