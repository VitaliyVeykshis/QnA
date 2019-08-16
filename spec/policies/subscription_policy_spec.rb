require 'rails_helper'

RSpec.describe SubscriptionPolicy, type: :policy do
  subject { described_class.new(user, subscription) }

  context 'when visitor is guest' do
    let(:user) { nil }
    let(:subscription) { Subscription.new }

    it { is_expected.to forbid_actions(%i[destroy]) }
  end

  context 'when user is not subscription owner' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { question.subscriptions.first }

    it { is_expected.to forbid_actions(%i[destroy]) }
  end

  context 'when user is subscription owner' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:subscription) { question.subscriptions.first }

    it { is_expected.to permit_actions(%i[destroy]) }
  end
end
