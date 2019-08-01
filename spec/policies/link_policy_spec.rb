require 'rails_helper'

RSpec.describe LinkPolicy, type: :policy do
  subject { described_class.new(user, link) }

  context 'when visitor is guest' do
    let(:user) { nil }
    let(:link) { Link.new }

    it { is_expected.to forbid_actions(%i[destroy]) }
  end

  context 'when visitor is a authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }
    let(:link) { create(:link, linkable: question) }

    it { is_expected.to forbid_actions(%i[destroy]) }
  end

  context 'when visitor is a link author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, linkable: question) }

    it { is_expected.to permit_actions(%i[destroy]) }
  end
end
