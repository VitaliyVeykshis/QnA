require 'rails_helper'

RSpec.describe IdentifyResource, type: :interactor do
  describe '.call' do
    context 'when given valid params' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:context) { IdentifyResource.call(params: { question_id: question.id }) }

      it 'returns identifyed resource' do
        expect(context.resource).to eq question
      end
    end

    context 'when given invalid params' do
      let(:context) { IdentifyResource.call(params: {}) }

      it 'returns nil' do
        expect(context.resource).to be_nil
      end
    end

    context 'when given wrong id' do
      let(:context) { IdentifyResource.call(params: { question_id: 0 }) }

      it 'returns nil' do
        expect(context.resource).to be_nil
      end
    end
  end
end
