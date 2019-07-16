require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_up' do
    it 'votes up' do
      resource.vote_up(user)

      expect(resource.rating).to eq(1)
    end

    it "accepts user's vote" do
      expect { resource.vote_up(user) }.to change(resource.votes, :count).by(1)
    end

    it 'has one up vote if the vote has not changed' do
      resource.vote_up(user)
      resource.vote_up(user)

      expect(resource.rating).to eq(1)
    end
  end

  describe '#vote_down' do
    it 'votes down' do
      resource.vote_down(user)

      expect(resource.rating).to eq(-1)
    end

    it "accepts user's vote" do
      expect { resource.vote_down(user) }.to change(resource.votes, :count).by(1)
    end

    it 'has one down vote if the vote has not changed' do
      resource.vote_down(user)
      resource.vote_down(user)

      expect(resource.rating).to eq(-1)
    end
  end

  describe '#rating' do
    let(:users) { create_list(:user, 3) }

    it 'returns rating of resource' do
      resource.vote_up(users[0])
      resource.vote_down(users[1])
      resource.vote_up(users[2])

      expect(resource.rating).to eq(1)
    end
  end
end
