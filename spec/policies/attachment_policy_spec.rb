require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentPolicy, type: :policy do
  subject { described_class.new(user, record) }

  context 'when visitor is guest' do
    let(:user) { nil }
    let(:question) { create(:question, :with_attachments, user: create(:user)) }
    let(:record) { question.files.first }

    it { is_expected.to forbid_actions(%i[destroy]) }
  end

  context 'when a visitor is an authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_attachments, user: create(:user)) }
    let(:record) { question.files.first }

    it { is_expected.to forbid_actions(%i[destroy]) }
  end

  context 'when visitor is a resource author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_attachments, user: user) }
    let(:record) { question.files.first }

    it { is_expected.to permit_actions(%i[destroy]) }
  end
end
