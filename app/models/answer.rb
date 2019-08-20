class Answer < ApplicationRecord
  include Votable
  include Commentable
  include Indexable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :accepted_first, -> { order(accepted: :desc) }

  after_create :broadcast, :notify

  def accept!
    transaction do
      question.answers.find_by(accepted: true)&.update!(accepted: false)
      update!(accepted: true)
      question.badge&.update!(user: user)
    end
  end

  def search_result
    { title: question.title[0..20], body: body[0..100], link_to: question }
  end

  private

  def broadcast
    AnswersChannel.broadcast_to(
      question,
      answer: GetAnswerData.call(answer: self).data
    )
  end

  def notify
    NewAnswerJob.perform_later(self)
  end
end
