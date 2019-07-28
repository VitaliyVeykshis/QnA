require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  context 'when valid subscription' do
    before { subscribe(question_id: question.id) }

    it 'subscribes to a stream' do
      expect(subscription).to be_confirmed
    end

    it 'subscribes to question stream' do
      expect(subscription).to have_stream_for(question)
    end
  end

  context 'when invalid subscription' do
    before { subscribe }

    it 'rejects' do
      expect(subscription).to be_rejected
    end
  end
end
