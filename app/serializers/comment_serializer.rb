class CommentSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :body,
             :commentable_type,
             :commentable_id,
             :user_id,
             :created_at,
             :updated_at
end
