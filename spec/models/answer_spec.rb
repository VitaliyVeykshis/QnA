require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answers) { create_list(:answer, 3, question: question, user: user) }

  before { answers[1].accept! }

  describe 'Associations' do
    it { should belong_to :question }
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe '.accepted_first' do
    it 'returns answers list where accepted answer is first' do
      expect(answers[1]).to eq question.answers.accepted_first[0]
    end
  end

  describe '#accept!' do
    it 'accept answer' do
      expect(answers[1]).to be_accepted
    end

    it 'remove accept from old accepted answer' do
      answers[2].accept!
      answers[1].reload

      expect(answers[1]).not_to be_accepted
    end
  end
end
