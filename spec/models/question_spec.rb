require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'Associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribers).through(:subscriptions).source(:user) }
    it { should have_one(:badge).dependent(:destroy) }
    it { should belong_to :user }
  end

  describe 'Attachment association' do
    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'Callbacks' do
    let(:question) { build(:question, user: user) }

    it 'after_create subscribes question author' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end

    it "broadcasts new question to 'questions' channel" do
      expected = { question: hash_including(question.attributes.compact) }

      expect { question.save }
        .to have_broadcasted_to('questions').with(include(expected))
    end
  end

  describe '.created_last_24_hours' do
    let!(:questions) { create_list(:question, 2, user: user) }

    it 'returns questions created last 24 hours' do
      Timecop.travel(1.day)
      expect(Question.created_last_24_hours).to include(*questions)
    end

    it 'not return questions older then last 24 hours' do
      Timecop.travel(3.days)
      expect(Question.created_last_24_hours).not_to include(*questions)
    end
  end

  describe '#accepted_answer' do
    it 'return accepted answer' do
      answers[1].accept!
      expect(question.accepted_answer).to eq answers[1]
    end
  end

  describe '#subscribe' do
    let(:another_user) { create(:user) }

    it 'adds subscriber' do
      question.subscribe(another_user)

      expect(question.subscribers).to include(another_user)
    end
  end

  describe '#subscribed?' do
    context 'when user is subscribed' do
      it 'returns true' do
        expect(question).to be_subscribed(user)
      end
    end

    context "when user isn't subscribed" do
      it 'returns false' do
        expect(question).not_to be_subscribed(create(:user))
      end
    end
  end

  describe '#subscription_of' do
    context 'when user is subscribed' do
      it 'returns subscription' do
        expect(question.subscription_of(user)).to eq user.subscriptions.first
      end
    end

    context "when user isn't subscribed" do
      let(:question) { create(:question) }

      it 'returns nil' do
        expect(question.subscription_of(user)).to be_nil
      end
    end
  end

  describe 'Concerns' do
    let(:resource) { create(:question, user: user) }

    it_behaves_like 'votable'
    it_behaves_like 'commentable'
  end
end
