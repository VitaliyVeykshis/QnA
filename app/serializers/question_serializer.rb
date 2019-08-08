class QuestionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :title,
             :body,
             :created_at,
             :updated_at,
             :user_id

  has_many :answers
  has_many :comments
  has_many :links
  belongs_to :user

  attribute :short_title do |object|
    object.title.truncate(7)
  end

  attribute :files, if: proc { |_, params|
    params.dig(:files) == true
  } do |object|
    FileSerializer.new(object.files)
  end
end
