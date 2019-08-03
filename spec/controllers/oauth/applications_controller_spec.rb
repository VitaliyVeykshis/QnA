require 'rails_helper'

RSpec.describe Oauth::ApplicationsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe 'GET #index' do
    context 'when authenticated user IS the owner' do
      let(:oauth_application) { create(:oauth_application, owner: user) }

      before { get :index }

      it 'assigns user applications to @applications' do
        expect(assigns(:applications)).to match_array user.oauth_applications
      end
    end

    context 'when authenticated user is NOT the owner' do
      let(:oauth_application) { create(:oauth_application, owner: create(:user)) }

      before { get :index }

      it 'not assigns user applications to @applications' do
        expect(assigns(:applications)).not_to include Doorkeeper::Application.first
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new application in the database' do
        expect do
          post :create, params: { owner_id: user, doorkeeper_application: attributes_for(:oauth_application) }
        end.to change(Doorkeeper::Application, :count).by(1)
      end

      it 'links the new application with owner' do
        expect do
          post :create, params: { owner_id: user, doorkeeper_application: attributes_for(:oauth_application) }
        end.to change(user.oauth_applications, :count).by(1)
      end

      it 'redirects to application show view' do
        post :create, params: { owner_id: user, doorkeeper_application: attributes_for(:oauth_application) }

        expect(response).to redirect_to oauth_application_path(user.oauth_applications.first)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the application' do
        expect do
          post :create, params: { owner_id: user, doorkeeper_application: attributes_for(:oauth_application, :invalid) }
        end.not_to change(Doorkeeper::Application, :count)
      end

      it 'renders application new tamplate' do
        post :create, params: { owner_id: user, doorkeeper_application: attributes_for(:oauth_application, :invalid) }

        expect(response).to render_template :new
      end
    end
  end
end