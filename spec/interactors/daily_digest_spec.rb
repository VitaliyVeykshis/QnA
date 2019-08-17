require 'rails_helper'

RSpec.describe DailyDigest, type: :interactor do
  let(:users) { create_list(:user, 3) }

  describe '.call' do
    it 'sends daily digest to all users' do
      users.each do |user|
        expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
      end

      subject.call
    end
  end
end
