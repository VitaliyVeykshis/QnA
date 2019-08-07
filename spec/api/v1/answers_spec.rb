require 'rails_helper'

describe 'Answers API', type: :request do
  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }
      let(:answers_json) { response_json.dig(:data) }
      let(:answer_json) { answers_json.first }

      before { do_request(method, api_path, json_options) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_json.size).to eq answers.size
      end

      it 'returns answers of question' do
        answers_from_json = json_data_attributes(response_json, &:to_json)
        expect(answers_from_json).to match_array answers.map(&:to_json)
      end

      it 'returns all public fields' do
        %i[id body user_id created_at updated_at].each do |attr|
          expect(answer_json.dig(:attributes, attr)).to eq answer.send(attr).as_json
        end
      end
    end
  end
end
