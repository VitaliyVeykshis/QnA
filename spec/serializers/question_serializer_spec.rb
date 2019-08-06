require 'rails_helper'

RSpec.describe QuestionSerializer, type: :serializer do
  let(:question) { create(:question, :with_attachments) }

  file_attributes = %i[id title body user_id created_at updated_at]

  context 'when receives single question' do
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 4, commentable: question) }
    let(:show_options) { { include: %i[comments links], params: { files: true } } }
    let(:serialized) { QuestionSerializer.new(question, show_options).serializable_hash }

    file_attributes.each do |attr|
      it "serialize file with #{attr}" do
        expect(serialized.dig(:data, :attributes, attr)).to eq question.send(attr)
      end
    end

    it 'serialized question contains links' do
      links_from_serialized = json_included_attributes_of(serialized, :link, &:to_json)

      expect(links_from_serialized).to match_array links.map(&:to_json)
    end

    it 'serialized question contains comments' do
      comments_from_serialized = json_included_attributes_of(serialized, :comment, &:to_json)

      expect(comments_from_serialized).to match_array comments.map(&:to_json)
    end

    it 'serialized question contains files' do
      files = [{ id: question.files.first.id,
                 name: question.files.first.filename.to_s,
                 url: url_for(question.files.first),
                 created_at: question.files.first.created_at },
               { id: question.files.last.id,
                 name: question.files.last.filename.to_s,
                 url: url_for(question.files.last),
                 created_at: question.files.last.created_at }]
      serialized_files = serialized.dig(:data, :attributes, :files).serializable_hash
      files_from_serialized = json_data_attributes(serialized_files)

      expect(files_from_serialized).to match_array files
    end
  end

  context 'when receives list of questions' do
    let(:questions) { create_list(:question, 3) }
    let(:serialized) { QuestionSerializer.new(questions).serializable_hash }

    it 'serialize list of questions' do
      expect(serialized.dig(:data).size).to eq questions.size
    end

    it 'serialized list contains questions' do
      without_short_title = json_data_attributes(serialized).map do |question|
        question.except(:short_title)
      end
      questions_from_serialized = without_short_title.map(&:to_json)

      expect(questions_from_serialized).to match_array questions.map(&:to_json)
    end
  end
end
