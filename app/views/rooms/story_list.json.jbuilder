json.array!(@stories) do |story|
  json.extract! story, :id, :link, :desc
end
