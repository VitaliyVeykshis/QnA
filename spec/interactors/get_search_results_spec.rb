require 'rails_helper'

RSpec.describe GetSearchResults, type: :interactor do
  let(:question) { create(:question) }

  describe '.call' do
    it 'send search method' do
      expect(ThinkingSphinx)
        .to receive(:search).with(ThinkingSphinx::Query.escape(question.title), classes: [Question])

      GetSearchResults.call(query: question.title, category: Question)
    end
  end
end
