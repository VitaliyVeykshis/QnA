require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_json) { json['data'].first }
      let(:options) do
        { params: { access_token: access_token.token },
          headers: headers }
      end

      before { do_request(method, api_path, options) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json.dig('data').size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_json.dig('attributes', attr)).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_json.dig('relationships', 'user', 'data', 'id').to_i).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_json.dig('attributes', 'short_title')).to eq question.title.truncate(7)
      end
    end
  end
end
