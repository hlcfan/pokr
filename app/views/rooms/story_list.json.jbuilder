json.groomed do
  json.array!(@stories[:groomed]) do |story|
    json.extract! story, :id, :link, :desc, :point
  end
end

json.ungroomed do
  json.array!(@stories[:un_groomed]) do |story|
    json.extract! story, :id, :link, :desc
  end
end

