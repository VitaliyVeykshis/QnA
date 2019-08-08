require 'rails_helper'

describe 'Pofiles API', type: :request do
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:me) { create(:user) }
      let(:options) { json_options(user: me) }

      it_behaves_like 'API success response', :ok

      before { do_request(method, api_path, options) }

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
      let!(:users) { create_list(:user, 3) }
      let(:users_list) { response_json.dig(:data) }
      let(:options) { json_options(user: me) }

      it_behaves_like 'API success response', :ok

      before { do_request(method, api_path, options) }

      it 'returns list of users' do
        expect(users_list.size).to eq User.where.not(id: me.id).count
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
