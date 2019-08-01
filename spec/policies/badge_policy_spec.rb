require 'rails_helper'

RSpec.describe BadgePolicy, type: :policy do
  subject { described_class.new(user, question) }

  context 'when visitor is guest' do
    let(:user) { nil }
    let(:question) { Question.new }

    it { is_expected.to permit_actions(%i[index]) }
  end

  context 'when visitor is a authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }

    it { is_expected.to permit_actions(%i[index]) }
  end
end
