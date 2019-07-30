require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #github' do
    let(:auth) { request.env['omniauth.auth'] }

    github_auth_hash

    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    it 'finds identity from oauth data' do
      expect(User).to receive(:find_for_oauth).with(auth).and_call_original

      get :github
    end

    context 'when user exists' do
      let(:user) { create(:user) }

      before do
        OmniAuth.config.add_mock(:github, info: { email: user.email })
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
        get :github
      end

      it 'sign in user' do
        expect(subject.current_user).to eq User.first
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when user does not exist' do
      before { get :github }

      it 'sign in user' do
        expect(subject.current_user).to eq User.first
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
