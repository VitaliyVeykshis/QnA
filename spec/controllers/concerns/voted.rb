require 'rails_helper'

shared_examples_for 'voted' do
  describe 'POST #vote_up' do
    context 'Author of resource' do
      it 'tries to like resource' do
        expect do
          post :vote_up, params: { id: author_resource }
        end.to not_change(author_resource.votes, :count)
      end
    end

    context 'Not author of resource' do
      it 'likes resource' do
        expect do
          post :vote_up, params: { id: not_author_resource }
        end.to change(not_author_resource.votes, :count).by(1)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'Author of resource' do
      it 'tries to dislike resource' do
        expect do
          post :vote_down, params: { id: author_resource }
        end.to not_change(author_resource.votes, :count)
      end
    end

    context 'Not author of resource' do
      it 'dislikes resource' do
        expect do
          post :vote_down, params: { id: not_author_resource }
        end.to change(not_author_resource.votes, :count).by(1)
      end
    end
  end
end
