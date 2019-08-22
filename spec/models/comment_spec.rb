require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Associations' do
    it { should belong_to :commentable }
    it { should belong_to :user }
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe '#search_result' do
    let(:comment) { create(:comment) }

    it 'search_result contains title' do
      expect(comment.search_result[:title]).to eq comment.commentable.title
    end

    it 'search_result contains body' do
      expect(comment.search_result[:body]).to eq comment.body
    end

    it 'search_result contains link_to' do
      expect(comment.search_result[:link_to]).to eq comment.commentable
    end
  end
end
