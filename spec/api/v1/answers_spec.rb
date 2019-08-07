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

  describe 'POST #create /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:user) { create(:user) }
      let(:addition) { { answer: attributes_for(:answer) } }
      let(:options) { json_options(user: user, addition: addition) }

      it 'returns 200 status' do
        do_request(method, api_path, options)

        expect(response).to be_successful
      end

      context 'when valid attributs' do
        it 'saves new answer in database' do
          expect { do_request(method, api_path, options) }
            .to change(Answer, :count).by(1)
        end

        it 'sets current_user as answer author' do
          expect { do_request(method, api_path, options) }
            .to change(user.answers, :count).by(1)
        end

        it 'links the new answer with question' do
          expect { do_request(method, api_path, options) }
            .to change(question.answers, :count).by(1)
        end

        it "broadcasts new answer to question channel" do
          answer_attributes = attributes_for(:answer)
          addition = { question_id: question, answer: answer_attributes }
          options = json_options(user: user, addition: addition)
          expected = { answer: a_hash_including(answer_attributes) }

          expect do
            do_request(method, api_path, options)
          end.to have_broadcasted_to(question).from_channel(AnswersChannel).with(include(expected))
        end

        it 'renders json with answer' do
          do_request(method, api_path, options)

          answer_json = AnswerSerializer.new(Answer.last).serialized_json

          expect(response_json.to_json).to eq answer_json
        end

        it 'renders json with status :created' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :created
        end
      end

      context 'when invalid attributs' do
        let(:addition) { { answer: attributes_for(:answer, :invalid) } }
        let(:options) { json_options(user: user, addition: addition) }

        it 'does not save new answer in database' do
          expect { do_request(method, api_path, options) }
            .not_to change(Answer, :count)
        end

        it 'renders json with error message' do
          do_request(method, api_path, options)

          expect(response.body).to eq "{\"body\":[\"can't be blank\"]}"
        end

        it 'renders json with status :unprocessable_entity' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH #update /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:user) { answer.user }

      context 'when author with valid attributes' do
        let(:addition) { { answer: attributes_for(:answer, :new) } }
        let(:options) { json_options(user: user, addition: addition) }

        it 'returns 200 status' do
          do_request(method, api_path, options)
          expect(response).to be_successful
        end

        it 'renders json with status :no_content' do
          do_request(method, api_path, options)
          expect(response).to have_http_status :no_content
        end

        it 'changes answer attributes' do
          do_request(method, api_path, options)
          answer.reload
          expect(answer.body).to eq 'New body'
        end
      end

      context 'when author with invalid attributes' do
        let(:addition) { { answer: attributes_for(:answer, :invalid) } }
        let(:options) { json_options(user: user, addition: addition) }

        it 'does not change answer attributes' do
          expect { do_request(method, api_path, options) }
            .to not_change(answer, :body)
        end

        it 'renders json with error message' do
          do_request(method, api_path, options)

          expect(response.body).to eq "{\"body\":[\"can't be blank\"]}"
        end

        it 'renders json with status :unprocessable_entity' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'when not author' do
        let(:addition) { { answer: attributes_for(:answer) } }
        let(:options) { json_options(addition: addition) }

        it 'does not change answer attributes' do
          expect { do_request(method, api_path, options) }
            .to not_change(answer, :body)
        end

        it 'response status :forbidden' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :forbidden
        end
      end
    end
  end
end
