require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe 'Associations' do
    it { should belong_to :badgeable }
  end

  describe 'Attachment association' do
    it 'have one attached image' do
      expect(Badge.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe 'Validations' do
    it { should validate_presence_of :title }
  end
end