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
        %i[id body question_id user_id accepted created_at updated_at].each do |attr|
          expect(answer_json.dig(:attributes, attr)).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_attachments) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:answer_json) { response_json.dig(:data) }

      before { do_request(method, api_path, json_options) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %i[id body question_id user_id accepted created_at updated_at].each do |attr|
          expect(answer_json.dig(:attributes, attr)).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_json.dig(:relationships, :user, :data, :id).to_i).to eq answer.user.id
      end

      it 'contains list of attachet files' do
        files_from_json = response_json.dig(:data, :attributes, :files)
        files_from_answer = FileSerializer.new(answer.files)

        expect(files_from_json.to_json).to eq files_from_answer.to_json
      end
    end

    context 'when answer contains comments' do
      let!(:comments) { create_list(:comment, 2, commentable: answer) }

      before { do_request(method, api_path, json_options) }

      it 'contains list of comments' do
        comments_from_json = json_included_attributes_of(response_json, 'comment', &:to_json)

        expect(comments_from_json).to match_array comments.map(&:to_json)
      end
    end

    context 'when answer contains links' do
      let!(:links) { create_list(:link, 2, linkable: answer) }

      before { do_request(method, api_path, json_options) }

      it 'contains list of links' do
        comments_from_json = json_included_attributes_of(response_json, 'link', &:to_json)

        expect(comments_from_json).to match_array links.map(&:to_json)
      end
    end
  end
end
