module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(voter)
    voted_by = voted_up_by?(voter)
    votes.where(user: voter).destroy_all
    votes.create!(vote_for: 1, user: voter) unless voted_by
  end

  def vote_down(voter)
    voted_by = voted_down_by?(voter)
    votes.where(user: voter).destroy_all
    votes.create!(vote_for: -1, user: voter) unless voted_by
  end

  def rating
    votes.sum(:vote_for)
  end

  private

  def voted_up_by?(voter)
    votes.exists?(user: voter, vote_for: 1)
  end

  def voted_down_by?(voter)
    votes.exists?(user: voter, vote_for: -1)
  end
end
