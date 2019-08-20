class Question < ApplicationRecord
  include Votable
  include Commentable
  include Indexable

  belongs_to :user
  has_one :badge, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create { subscribe(user) }
  after_create :broadcast

  scope :created_last_24_hours, lambda {
    where(created_at: 1.day.ago.midnight..Time.current.midnight)
  }

  def accepted_answer
    answers.find_by(accepted: true)
  end

  def subscribe(user)
    subscriptions.create(user: user)
  end

  def subscribed?(user)
    subscribers.exists?(user.id)
  end

  def subscription_of(user)
    subscriptions.find_by(user_id: user&.id)
  end

  def search_result
    { title: title[0..20], body: body[0..100], link_to: self }
  end

  private

  def broadcast
    ActionCable.server.broadcast('questions', question: self.as_json)
  end
end
