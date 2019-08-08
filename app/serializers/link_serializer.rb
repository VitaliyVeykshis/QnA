class LinkSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :name,
             :url,
             :linkable_type,
             :linkable_id,
             :created_at,
             :updated_at
end
