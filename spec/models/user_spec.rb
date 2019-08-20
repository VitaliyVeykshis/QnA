require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'Associations' do
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many(:badges).dependent(:nullify) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:identities).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:oauth_applications).dependent(:destroy).class_name('Doorkeeper::Application')}
  end

  describe '.find_for_oauth' do
    let(:auth) { create(:auth, :github) }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:call).with(auth: auth).and_call_original

      User.find_for_oauth(auth)
    end

    it 'returns user' do
      expect(User.find_for_oauth(auth)).to eq User.last
    end
  end

  describe '#author?' do
    let(:second_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'is author' do
      expect(user).to be_author(question)
    end

    it 'is not author' do
      expect(second_user).not_to be_author(question)
    end
  end

  describe '#voted_up_on?' do
    let(:question) { create(:question, user: create(:user)) }

    it 'returns true if user has voted up' do
      question.vote_up(user)

      expect(user.voted_up_on?(question)).to be true
    end

    it 'returns false if user has not voted up' do
      question.vote_down(user)

      expect(user.voted_up_on?(question)).to be false
    end
  end

  describe '#voted_down_on?' do
    let(:question) { create(:question, user: create(:user)) }

    it 'returns true if user has voted down' do
      question.vote_down(user)

      expect(user.voted_down_on?(question)).to be true
    end

    it 'returns false if user has not voted down' do
      question.vote_up(user)

      expect(user.voted_down_on?(question)).to be false
    end
  end

  describe '#search_result' do
    it 'search_result contains user email' do
      expect(user.search_result[:body]).to eq user.email
    end
  end
end
