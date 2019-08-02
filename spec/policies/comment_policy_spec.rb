require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class.new(user, comment) }

  context 'when visitor is guest' do
    let(:user) { nil }
    let(:comment) { Comment.new }

    it { is_expected.to forbid_actions(%i[create]) }
  end

  context 'when visitor is a authenticated user' do
    let(:user) { create(:user) }
    let(:comment) { Comment.new }

    it { is_expected.to permit_actions(%i[create]) }
  end
end
