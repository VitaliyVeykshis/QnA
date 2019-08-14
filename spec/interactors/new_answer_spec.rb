require 'rails_helper'

RSpec.describe NewAnswer, type: :interactor do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe '.call' do
    it 'sends new answer notify to question author' do
      expect(NewAnswerMailer)
        .to receive(:notify).with(question.user, answer).and_call_original

      NewAnswer.call(answer: answer)
    end
  end
end
