json.array!(@items) do |item|
  json.extract! item, :id, :name, :image
  json.url item_url(item, format: :json)
end
