require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  before { sign_in_as(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'links the new answer with author' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.to change(user.answers, :count).by(1)
      end

      it 'renders answer create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders answer create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when author' do
      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when not author' do
      let(:second_user) { create(:user) }
      let!(:second_answer) { create(:answer, question: question, user: second_user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: second_answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: second_answer }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    context 'when author with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when author with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when not author' do
      before { sign_in_as(create(:user)) }

      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'PATCH #accept' do
    context 'when question author' do
      it 'accept answer' do
        patch :accept, params: { id: answer }, format: :js
        expect(question.accepted_answer).to eq answer
      end
    end

    context 'when not author of question' do
      before { sign_in_as(create(:user)) }

      it 'accept answer' do
        patch :accept, params: { id: answer }, format: :js
        expect(question.accepted_answer).not_to eq answer
      end
    end
  end
end
