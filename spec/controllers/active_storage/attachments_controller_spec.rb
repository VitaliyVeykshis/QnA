require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_attachments, user: user) }

  describe 'DELETE #destroy' do
    context 'when author' do
      before { sign_in_as(user) }

      it 'deletes attachment' do
        expect do
          delete :destroy, params: { id: question.files[0].id }, format: :js
        end.to change(question.files, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.files[0].id }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when not author' do
      before { sign_in_as(create(:user)) }

      it 'not deletes attachment' do
        expect do
          delete :destroy, params: { id: question.files[0].id }, format: :js
        end.not_to change(question.files, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.files[0].id }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end