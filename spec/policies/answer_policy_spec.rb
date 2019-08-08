require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  subject { described_class.new(user, answer) }

  context 'when a visitor is a guest' do
    let(:user) { nil }
    let(:answer) { Answer.new }

    it { is_expected.to permit_actions(%i[show index]) }
    it { is_expected.to forbid_actions(%i[create update destroy vote_up vote_down accept]) }
  end

  context 'when a visitor is an authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }
    let(:answer) { create(:answer, question: question, user: create(:user)) }

    it { is_expected.to permit_actions(%i[show index create vote_up vote_down]) }
    it { is_expected.to forbid_actions(%i[update destroy accept]) }
  end

  context 'when a visitor is an answer author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }
    let(:answer) { create(:answer, question: question, user: user) }

    it { is_expected.to permit_actions(%i[show index create update destroy]) }
    it { is_expected.to forbid_actions(%i[vote_up vote_down]) }
  end

  context 'when a visitor is a question author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: create(:user)) }

    it { is_expected.to permit_actions(%i[accept]) }
  end
end
