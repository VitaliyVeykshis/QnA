require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  subject { described_class.new(user, question) }

  context 'when visitor is guest' do
    let(:user) { nil }
    let(:question) { Question.new }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_actions(%i[create update destroy vote_up vote_down]) }
  end

  context 'when visitor is a authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }

    it { is_expected.to permit_actions(%i[index show create vote_up vote_down]) }
    it { is_expected.to forbid_actions(%i[update destroy]) }
  end

  context 'when visitor is a question author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { is_expected.to permit_actions(%i[index show create update destroy]) }
    it { is_expected.to forbid_actions(%i[vote_up vote_down]) }
  end
end
