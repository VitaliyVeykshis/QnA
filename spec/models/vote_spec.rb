require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'Validations' do
    it { should validate_presence_of :vote_for }
    it { should allow_value(1, -1).for(:vote_for) }
  end

  describe 'Uniqueness' do
    let!(:user) { create(:user) }
    let!(:votable) { create(:question, user: user) }
    let!(:vote) { create(:vote, vote_for: 1, votable: votable, user: user) }

    it { should validate_uniqueness_of(:user).scoped_to(:votable_id, :votable_type) }
  end
end