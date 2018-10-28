json.success "true"
json.data do
  json.array! @rooms do |room|
    json.name room.name
    json.id room.slug
    json.create_date l(room.created_at, format: :long)
    json.url room_url(room.slug)
  end
end
