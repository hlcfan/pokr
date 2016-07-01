json.array!(@stories) do |story|
  json.extract! story, :id, :link, :point
end
