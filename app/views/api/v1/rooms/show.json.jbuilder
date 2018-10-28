json.success "true"
json.data do
  json.array! @room.groomed_stories do |story|
    json.link story[1]
    json.point story[2]
  end
end
