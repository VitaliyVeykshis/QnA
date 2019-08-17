require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions) { create_list(:question, 2) }

    it 'renders the header' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body with questions' do
      Timecop.travel(1.day)

      questions.each do |question|
        expect(mail.body.encoded).to include(question.title)
      end
    end

    it 'renders the body with questions url' do
      Timecop.travel(1.day)

      questions.each do |question|
        expect(mail.body.encoded).to include(questions_url(question))
      end
    end
  end
end
