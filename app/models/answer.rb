class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :accepted_first, -> { order(accepted: :desc) }

  def accept!
    transaction do
      question.answers.find_by(accepted: true)&.update!(accepted: false)
      update!(accepted: true)
      question.badge&.update!(user: user)
    end
  end
end
