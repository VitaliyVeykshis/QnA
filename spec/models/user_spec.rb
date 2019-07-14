require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many(:badges).dependent(:nullify) }
  end

  describe '#author?' do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'is author' do
      expect(user).to be_author(question)
    end

    it 'is not author' do
      expect(second_user).not_to be_author(question)
    end
  end
end
