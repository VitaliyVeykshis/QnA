module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(voter)
    votes.where(user: voter).destroy_all
    votes.create!(vote_for: 1, user: voter)
  end

  def vote_down(voter)
    votes.where(user: voter).destroy_all
    votes.create!(vote_for: -1, user: voter)
  end

  def rating
    votes.sum(:vote_for)
  end
end