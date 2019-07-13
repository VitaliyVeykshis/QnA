require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:link) { build(:link, linkable: question) }

  describe 'Associations' do
    it { should belong_to :linkable }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }

    %w[http://www.google.com https://www.google.com].each do |valid_url|
      it "#{valid_url.inspect} is a valid url" do
        link.url = valid_url
        expect(link).to be_valid
      end
    end

    %w[google.com www.google.com ftp://google.com].each do |invalid_url|
      it "#{invalid_url.inspect} is an invalid url" do
        link.url = invalid_url
        expect(link).to be_invalid
      end
    end
  end

  describe '#gist?' do
    let(:gist) { create(:link, :gist, linkable: question) }

    it 'returns true when link is a gist' do
      expect(gist).to be_gist
    end

    it 'returns false when link is not a gist' do
      expect(link).not_to be_gist
    end
  end

  describe '#gist_files' do
    let(:gist) { create(:link, :gist, linkable: question) }

    it 'returns gist files' do
      expect(gist.gist_files.first).to include(content: 'gist text')
    end
  end
end
