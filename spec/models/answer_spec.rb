require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:badge) { create(:badge, question: question) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }

  before { answers[1].accept! }

  describe 'Associations' do
    it { should belong_to :question }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'Attachment association' do
    it 'have many attached files' do
      expect(Answer.new.files)
        .to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  it { should accept_nested_attributes_for :links }

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe 'Callbacks' do
    let!(:answer) { build(:answer, question: question) }

    it 'after create broadcasts to question channel' do
      expected = { answer: hash_including(answer.as_json(only: %i[body])) }

      expect { answer.save }
        .to have_broadcasted_to(question).from_channel(AnswersChannel)
                                         .with(include(expected))
    end

    it 'after create broadcasts new answer to question channel' do
      expect(GetAnswerData)
        .to receive(:call).with(answer: answer).and_call_original

      answer.save
    end

    it 'after create notifies subscribed users about new answer' do
      expect(NewAnswerJob)
        .to receive(:perform_later).with(answer).and_call_original

      answer.save
    end
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

    it 'give badge to accepted answer author' do
      answers[2].accept!
      user.reload

      expect(user.badges.first).to eq badge
    end
  end

  describe '#search_result' do
    let(:answer) { create(:answer) }

    it 'search_result contains title' do
      expect(answer.search_result[:title]).to eq answer.question.title
    end

    it 'search_result contains body' do
      expect(answer.search_result[:body]).to eq answer.body
    end

    it 'search_result contains link_to' do
      expect(answer.search_result[:link_to]).to eq answer.question
    end
  end

  describe 'Concerns' do
    let(:resource) { create(:answer, question: question, user: user) }

    it_behaves_like 'votable'
    it_behaves_like 'commentable'
  end
end
