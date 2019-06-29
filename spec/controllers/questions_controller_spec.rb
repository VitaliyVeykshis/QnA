require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { sign_in_as(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it 'links the new question with author' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to Question.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when author' do
      it 'deletes question' do
        question
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions index view' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'when not author' do
      let(:second_user) { create(:user) }
      let!(:second_question) { create(:question, user: second_user) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: second_question } }.not_to change(Question, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: second_question }

        expect(response).to redirect_to question_path(second_question)
      end
    end
  end
end
