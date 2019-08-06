require 'rails_helper'

describe 'Questions API', type: :request do
  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_json) { response_json.dig(:data).first }

      before { do_request(method, api_path, valid_json_options) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(response_json.dig(:data).size).to eq 2
      end

      it 'returns all public fields' do
        %i[id title body user_id created_at updated_at].each do |attr|
          expect(question_json.dig(:attributes, attr)).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_json.dig(:relationships, :user, :data, :id).to_i).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_json.dig(:attributes, :short_title)).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_attachments) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:question_json) { response_json.dig(:data) }

      before { do_request(method, api_path, valid_json_options) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %i[id title body user_id created_at updated_at].each do |attr|
          expect(question_json.dig(:attributes, attr)).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_json.dig(:relationships, :user, :data, :id).to_i).to eq question.user.id
      end

      it 'contains list of attachet files' do
        files_from_json = response_json.dig(:data, :attributes, :files)
        files_from_question = FileSerializer.new(question.files)

        expect(files_from_json.to_json).to eq files_from_question.to_json
      end
    end

    context 'when question contains comments' do
      let!(:comments) { create_list(:comment, 2, commentable: question) }

      before { do_request(method, api_path, valid_json_options) }

      it 'contains list of comments' do
        comments_from_json = json_included_attributes_of(response_json, 'comment', &:to_json)

        expect(comments_from_json).to match_array comments.map(&:to_json)
      end
    end

    context 'when question contains links' do
      let!(:links) { create_list(:link, 2, linkable: question) }

      before { do_request(method, api_path, valid_json_options) }

      it 'contains list of links' do
        comments_from_json = json_included_attributes_of(response_json, 'link', &:to_json)

        expect(comments_from_json).to match_array links.map(&:to_json)
      end
    end
  end
end
