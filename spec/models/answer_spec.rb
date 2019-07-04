require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'Associations' do
    it { should belong_to :question }
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe '.accepted_first' do
    it 'returns answers list where accepted answer is first' do
      answers[1].accept!

      expect(answers[1]).to eq question.answers.accepted_first[0]
    end
  end

  describe '#accept!' do
    it 'accept answer' do
      answers[1].accept!

      expect(answers[1]).to be_accepted
    end
  end
end
