json.extract! @room, :id, :name, :slug, :created_at, :updated_at
json.url room_url(@room.slug)
