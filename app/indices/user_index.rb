ThinkingSphinx::Index.define :user, with: :real_time do
  # fields
  indexes email, sortable: true

  # attributes
  has admin, type: :boolean
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
