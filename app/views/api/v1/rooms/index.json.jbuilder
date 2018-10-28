json.success "true"
json.data do
  json.array! @rooms do |room|
    json.id room.slug
    json.name room.name
    json.create_date l(room.created_at, format: :long)
    json.link room_url(room.slug)
  end
end
