json.success "true"
json.data do
  json.array! @schemes do |scheme|
    json.name scheme.name
    json.id scheme.slug
  end
end
