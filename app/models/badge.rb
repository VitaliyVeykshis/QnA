class Badge < ApplicationRecord
  belongs_to :badgeable, polymorphic: true

  has_one_attached :image

  validates :title, presence: true
end
