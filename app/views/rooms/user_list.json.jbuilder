json.array!(@users) do |user|
  json.extract! user, :uid, :name, :display_role, :points, :voted, :avatar_thumb
end
