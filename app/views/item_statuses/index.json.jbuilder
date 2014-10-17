json.array!(@item_statuses) do |item_status|
  json.extract! item_status, :name
  json.url item_status_url(item_status, format: :json)
end