require 'rails_helper'

describe 'Pofiles API', type: :request do
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:options) do
        { params: { access_token: access_token.token,
                    format: :json } }
      end

      before { do_request(method, api_path, options) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %i[id email created_at updated_at].each do |attr|
          expect(response_json.dig(:data, :attributes, attr)).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %i[password encrypted_password].each do |attr|
          expect(response_json.dig(:data, :attributes)).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/index' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:me) { create(:user) }
      let(:oauth_application) { create(:oauth_application, owner: me) }
      let(:access_token) { create(:access_token, application: oauth_application, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 3) }
      let(:users_list) { response_json.dig(:data) }
      let(:options) do
        { params: { access_token: access_token.token,
                    format: :json } }
      end

      before { do_request(method, api_path, options) }

      it 'returns list of users' do
        expect(users_list.size).to eq users.size
      end

      it 'returns users profiles' do
        users.each do |user_profile|
          expect(users_list.to_json).to include(user_profile.to_json)
        end
      end

      it 'does not return current resource owner profile' do
        users_list.each do |profile|
          expect(profile.to_json).not_to include(me.to_json)
        end
      end
    end
  end
end
