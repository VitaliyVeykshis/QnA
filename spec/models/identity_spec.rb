require 'rails_helper'

RSpec.describe Identity, type: :model do
  describe 'Associations' do
    it { should belong_to :user }
  end

  describe 'Validations' do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end
end
