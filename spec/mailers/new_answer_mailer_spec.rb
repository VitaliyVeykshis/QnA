require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { NewAnswerMailer.notify(user, answer) }

    it 'renders the header' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body with question link' do
      expect(mail.body.encoded)
        .to match(question.title)
        .and match(questions_url(question))
    end

    it 'renders the body with answer' do
      expect(mail.body.encoded).to include(answer.body)
    end
  end
end
