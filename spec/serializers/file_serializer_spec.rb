require 'rails_helper'

RSpec.describe FileSerializer, type: :serializer do
  let(:question) { create(:question, :with_attachments) }

  file_attributes = %i[id name url created_at]

  context 'when receives single file' do
    let(:serialized) { FileSerializer.new(question.files.first).serializable_hash }
    let(:file) do
      { id: question.files.first.id,
        name: question.files.first.filename.to_s,
        url: url_for(question.files.first),
        created_at: question.files.first.created_at }
    end

    file_attributes.each do |attr|
      it "serialize file with #{attr}" do
        expect(serialized.dig(:data, :attributes, attr)).to eq file.dig(attr)
      end
    end
  end

  context 'when receives list of files' do
    let(:serialized) { FileSerializer.new(question.files).serializable_hash }
    let(:files) do
      [{ id: question.files.first.id,
         name: question.files.first.filename.to_s,
         url: url_for(question.files.first),
         created_at: question.files.first.created_at },
       { id: question.files.last.id,
         name: question.files.last.filename.to_s,
         url: url_for(question.files.last),
         created_at: question.files.last.created_at }]
    end

    it 'serialize list of files' do
      expect(serialized.dig(:data).size).to eq question.files.count
    end

    it 'serialized list contains files' do
      files_from_json = json_data_attributes(serialized)

      expect(files_from_json).to match_array files
    end
  end
end
