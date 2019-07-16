require 'rails_helper'

shared_examples_for 'voted' do
  describe 'POST #vote_up' do
    context 'when user' do
      it 'likes resource' do
        expect do
          post :vote_up, params: { id: resource }
        end.to change(resource.votes, :count).by(1)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'when user' do
      it 'dislikes resource' do
        expect do
          post :vote_down, params: { id: resource }
        end.to change(resource.votes, :count).by(1)
      end
    end
  end
end
