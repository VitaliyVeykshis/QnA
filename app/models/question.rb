class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def accepted_answer
    answers.find_by(accepted: true)
  end
end
