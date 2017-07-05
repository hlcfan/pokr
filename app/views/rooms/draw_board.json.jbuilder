json.array!(@stories) do |story|
  json.extract! story, :id, :link, :point, :individuals
end
