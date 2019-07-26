class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_one :badge, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  def accepted_answer
    answers.find_by(accepted: true)
  end
end
