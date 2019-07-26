require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'Associations' do
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many(:badges).dependent(:nullify) }
    it { should have_many(:comments).dependent(:destroy) }
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
end
