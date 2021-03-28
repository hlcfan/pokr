json.groomed do
  json.array!(@stories[:groomed]) do |story|
    json.id story.id
    json.link story.link
    json.desc story.desc
    json.point story.point
  end
end

json.ungroomed do
  json.array!(@stories[:ungroomed]) do |story|
    json.id story.id
    json.link story.link
    json.desc story.desc
  end
end

