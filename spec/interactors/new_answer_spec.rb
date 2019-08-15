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

    it 'sends new answer notify to all subscribed users' do
      question.subscribers << create_list(:user, 2)

      question.subscribers.each do |subscriber|
        expect(NewAnswerMailer)
          .to receive(:notify).with(subscriber, answer).and_call_original
      end

      NewAnswer.call(answer: answer)
    end
  end
end
