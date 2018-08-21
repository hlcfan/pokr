json.array!(@stories) do |story|
  json.id story[0]
  json.link story[1]
  json.point story[2]
end
