json.array!(@stories) do |story|
  json.extract! story, :link, :desc
end
