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
      let(:options) { json_options }

      it_behaves_like 'API success response', :ok

      before { do_request(method, api_path, options) }

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
      let(:options) { json_options }

      it_behaves_like 'API success response', :ok

      before { do_request(method, api_path, options) }

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

      before { do_request(method, api_path, json_options) }

      it 'contains list of comments' do
        comments_from_json = json_included_attributes_of(response_json, 'comment', &:to_json)

        expect(comments_from_json).to match_array comments.map(&:to_json)
      end
    end

    context 'when question contains links' do
      let!(:links) { create_list(:link, 2, linkable: question) }

      before { do_request(method, api_path, json_options) }

      it 'contains list of links' do
        comments_from_json = json_included_attributes_of(response_json, 'link', &:to_json)

        expect(comments_from_json).to match_array links.map(&:to_json)
      end
    end
  end

  describe 'POST #create /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:user) { create(:user) }

      context 'when valid attributs' do
        let(:addition) { { question: attributes_for(:question) } }
        let(:options) { json_options(user: user, addition: addition) }

        it_behaves_like 'API success response', :created

        it 'saves new question in database' do
          expect { do_request(method, api_path, options) }
            .to change(Question, :count).by(1)
        end

        it 'sets current_user as question author' do
          expect { do_request(method, api_path, options) }
            .to change(user.questions, :count).by(1)
        end

        it "broadcasts new question to 'questions' channel" do
          question_attributes = attributes_for(:question)
          addition = { question: question_attributes }
          options = json_options(user: user, addition: addition)
          expected = { question: a_hash_including(question_attributes) }

          expect do
            do_request(method, api_path, options)
          end.to have_broadcasted_to('questions').with(include(expected))
        end

        it 'renders json with question' do
          do_request(method, api_path, options)

          question_json = QuestionSerializer.new(Question.last).serialized_json

          expect(response_json.to_json).to eq question_json
        end
      end

      context 'when invalid attributs' do
        let(:addition) { { question: attributes_for(:question, :invalid) } }
        let(:options) { json_options(user: user, addition: addition) }

        it 'does not save new question in database' do
          expect { do_request(method, api_path, options) }
            .not_to change(Question, :count)
        end

        it 'renders json with error message' do
          do_request(method, api_path, options)

          expect(response.body).to eq "{\"title\":[\"can't be blank\"]}"
        end

        it 'renders json with status :unprocessable_entity' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH #update /api/v1/questions' do
    let(:question) { create(:question) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:user) { question.user }

      context 'when author with valid attributes' do
        let(:addition) { { question: attributes_for(:question, :new) } }
        let(:options) { json_options(user: user, addition: addition) }

        it_behaves_like 'API success response', :no_content

        it 'changes question attributes' do
          do_request(method, api_path, options)
          question.reload
          expect(question.title).to eq 'New title'
          expect(question.body).to eq 'New body'
        end
      end

      context 'when author with invalid attributes' do
        let(:addition) { { question: attributes_for(:question, :invalid) } }
        let(:options) { json_options(user: user, addition: addition) }

        it 'does not change question attributes' do
          expect { do_request(method, api_path, options) }
            .to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'renders json with error message' do
          do_request(method, api_path, options)

          expect(response.body).to eq "{\"title\":[\"can't be blank\"]}"
        end

        it 'renders json with status :unprocessable_entity' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'when not author' do
        let(:addition) { { question: attributes_for(:question) } }
        let(:options) { json_options(addition: addition) }

        it 'does not change question attributes' do
          expect { do_request(method, api_path, options) }
            .to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'response status :forbidden' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :forbidden
        end
      end
    end
  end

  describe 'DELETE #destroy /api/v1/questions' do
    let!(:question) { create(:question) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'when access is authorized' do
      let(:user) { question.user }

      context 'when author' do
        let(:options) { json_options(user: user) }

        it_behaves_like 'API success response', :ok

        it 'deletes question' do
          expect { do_request(method, api_path, options) }
            .to change(Question, :count).by(-1)
        end

        it 'renders json with message' do
          message = 'Question deleted.'

          do_request(method, api_path, options)
          expect(response_json.dig(:message)).to eq message
        end
      end

      context 'when not author' do
        let(:options) { json_options }

        it 'does not delete question' do
          expect { do_request(method, api_path, options) }
            .not_to change(Question, :count)
        end

        it 'response with status :forbidden' do
          do_request(method, api_path, options)

          expect(response).to have_http_status :forbidden
        end
      end
    end
  end
end
