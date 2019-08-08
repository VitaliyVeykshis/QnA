class AnswerSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :body,
             :question_id,
             :created_at,
             :updated_at,
             :user_id,
             :accepted

  has_many :comments
  has_many :links
  belongs_to :user

  attribute :files, if: proc { |_, params|
    params.dig(:files) == true
  } do |object|
    FileSerializer.new(object.files)
  end
end
