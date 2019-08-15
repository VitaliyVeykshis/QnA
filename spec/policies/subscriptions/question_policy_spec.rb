require 'rails_helper'

RSpec.describe Subscriptions::QuestionPolicy, type: :policy do
  subject { described_class.new(user, question) }

  context 'when visitor is guest' do
    let(:user) { nil }
    let(:question) { Question.new }

    it { is_expected.to forbid_actions(%i[create]) }
  end

  context 'when visitor is a authenticated user' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it { is_expected.to permit_actions(%i[create]) }
  end

  context 'when user has subscription' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { is_expected.to forbid_actions(%i[create]) }
  end
end
