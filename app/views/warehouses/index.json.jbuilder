json.array!(@warehouses) do |warehouse|
  json.extract! warehouse, :w_id, :w_desc
  json.url warehouse_url(warehouse, format: :json)
end