require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

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

      it "broadcasts new question to 'questions' channel" do
        question_attributes = attributes_for(:question)
        expected = { question: a_hash_including(question_attributes) }

        expect do
          post :create, params: { question: question_attributes }
        end.to have_broadcasted_to('questions').with(include(expected))
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

      it 'renders json with error message' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response.body).to eq "{\"title\":[\"can't be blank\"]}"
      end

      it 'renders json with status :unprocessable_entity' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question, user: user) }

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
        from question_path(second_question)

        delete :destroy, params: { id: second_question }

        expect(response).to redirect_to question_path(second_question)
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }

    context 'when author with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: attributes_for(:question, :new) }, format: :js
        question.reload
        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :new) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when author with invalid attributes' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end
          .to not_change(question, :title)
          .and not_change(question, :body)
      end

      it 'renders json with error message' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response.body).to eq "{\"title\":[\"can't be blank\"]}"
      end

      it 'renders json with status :unprocessable_entity' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'when not author' do
      before { sign_in_as(create(:user)) }

      it 'does not change question attributes' do
        patch :update, params: { id: question, question: attributes_for(:question, :new) }, format: :js
        question.reload
        expect(question.title).not_to eq 'New title'
        expect(question.body).not_to eq 'New body'
      end
    end
  end

  describe 'Concerns' do
    let(:author_resource) { create(:question, user: user) }
    let(:not_author_resource) { create(:question, user: create(:user)) }

    it_behaves_like 'voted'
  end
end
