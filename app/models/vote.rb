class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :vote_for, presence: true, inclusion: [-1, 1]
end
