class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :nullify
  has_many :votes, dependent: :destroy

  def author?(resource)
    resource.user_id == id
  end

  def voted_up_on?(resource)
    votes.exists?(votable: resource, vote_for: 1)
  end

  def voted_down_on?(resource)
    votes.exists?(votable: resource, vote_for: -1)
  end
end
