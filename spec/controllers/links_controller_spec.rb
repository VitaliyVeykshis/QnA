require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'when author' do
      before { sign_in_as(user) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when not author' do
      before { sign_in_as(create(:user)) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: link }, format: :js }.not_to change(question.links, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end