class QuestionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at
  has_many :answers
  belongs_to :user

  attribute :short_title do |object|
    object.title.truncate(7)
  end
end
