require 'rails_helper'

RSpec.describe GetAnswerData, type: :interactor do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer_with_attachments_link_gist, question: question, user: user) }

  describe '.call' do
    context 'when given valid answer' do
      let(:context) { GetAnswerData.call(answer: answer) }

      %i[id body user_id].each do |attribute|
        it "returns hash with answer #{attribute}" do
          expect(context.data[attribute])
            .to eq answer.public_send(attribute)
        end
      end

      %i[id user_id].each do |attribute|
        it "answer question contains #{attribute}" do
          expect(context.data[:question][attribute])
            .to eq answer.question.public_send(attribute)
        end
      end

      %i[id name url gist_files].each do |attribute|
        it "answer links contains #{attribute}" do
          expect(context.data[:links].first[attribute])
            .to eq answer.links.first.public_send(attribute)
        end
      end

      it 'gist_files is nil when link is not a gist' do
        expect(context.data[:links].last[:gist_files])
          .to be_nil
      end

      it 'answer files contains id' do
        expect(context.data[:files].first[:id])
          .to eq answer.files.first.id
      end

      it 'answer files contains filename' do
        expect(context.data[:files].first[:filename])
          .to eq answer.files.first.filename.to_s
      end

      it 'answer files contains url' do
        expect(context.data[:files].first[:url])
          .to eq url_for(answer.files.first)
      end
    end
  end
end
