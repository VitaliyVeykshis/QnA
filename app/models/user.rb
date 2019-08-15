class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable,
         omniauth_providers: %i[github vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :oauth_applications, dependent: :destroy, class_name: 'Doorkeeper::Application', as: :owner

  def self.find_for_oauth(auth)
    FindForOauth.call(auth: auth).identity.user
  end

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
