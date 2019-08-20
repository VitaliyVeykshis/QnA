class Comment < ApplicationRecord
  include Indexable

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  def search_result
    { title: commentable.search_result[:title], body: body[0..100], link_to: commentable }
  end
end
