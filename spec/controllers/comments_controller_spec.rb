require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { sign_in_as(user) }

  describe 'POST #create' do
    context 'with valid question attributes' do
      it 'saves a new comment in the database' do
        expect do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'links a new comment with question' do
        expect do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        end.to change(question.comments, :count).by(1)
      end

      it 'links a new comment with user' do
        expect do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        end.to change(user.comments, :count).by(1)
      end

      it 'renders comment create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with valid answer attributes' do
      let(:answer) { create(:answer, question: question, user: user) }

      it 'saves a new comment in the database' do
        expect do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment) }, format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'links a new comment with answer' do
        expect do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment) }, format: :js
        end.to change(answer.comments, :count).by(1)
      end

      it 'links a new comment with user' do
        expect do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment) }, format: :js
        end.to change(user.comments, :count).by(1)
      end

      it 'renders comment create template' do
        post :create, params: { answer_id: answer, comment: attributes_for(:comment) }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders json with error message' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js

        expect(response.body).to eq "{\"body\":[\"can't be blank\"]}"
      end

      it 'renders json with status :unprocessable_entity' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end
