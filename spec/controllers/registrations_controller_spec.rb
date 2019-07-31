require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new_oauth_sign_up' do
    it 'renders finish_oauth_sign_up view' do
      get :new_oauth_sign_up

      expect(response).to render_template :new_oauth_sign_up
    end
  end

  describe 'PATCH #create_oauth_sign_up' do
    let(:user) { create(:user) }

    context 'when valid email' do
      it 'updates user unconfirmed email' do
        new_email = 'user@email.com'
        patch :create_oauth_sign_up, params: { email: new_email }, session: { 'devise.oauth_user_id': user.id }
        user.reload

        expect(user.unconfirmed_email).to eq new_email
      end

      it 'renders root_path' do
        new_email = 'user@email.com'
        patch :create_oauth_sign_up, params: { email: new_email }, session: { 'devise.oauth_user_id': user.id }

        expect(response).to redirect_to root_path
      end
    end

    context 'when invalid email' do
      before do
        patch :create_oauth_sign_up, params: { email: '' }, session: { 'devise.oauth_user_id': user.id }
      end

      it 'renders json with error message' do
        expect(response.body).to eq "{\"email\":[\"can't be blank\"]}"
      end

      it 'renders json with status :unprocessable_entity' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end
