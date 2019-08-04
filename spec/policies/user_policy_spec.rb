require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, User) }

  context 'when visitor is guest' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[index me]) }
  end

  context 'when visitor is a authenticated user' do
    let(:user) { create(:user) }

    it { is_expected.to permit_actions(%i[index me]) }
  end
end
