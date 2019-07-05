class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  scope :accepted_first, -> { order(accepted: :desc) }

  def accept!
    transaction do
      question.answers.find_by(accepted: true)&.update!(accepted: false)
      update!(accepted: true)
    end
  end
end
