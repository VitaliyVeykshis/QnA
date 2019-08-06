class FileSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id, &:id

  attribute :name do |object|
    object.filename.to_s
  end

  attribute :url do |object|
    Rails.application.routes.url_helpers.url_for(object)
  end

  attribute :created_at, &:created_at
end
