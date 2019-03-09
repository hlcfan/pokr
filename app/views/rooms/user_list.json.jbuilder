json.array!(@users) do |user|
  json.extract! user, :id, :name, :display_role, :points, :voted, :avatar_thumb
end
