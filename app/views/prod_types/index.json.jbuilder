json.array!(@prod_types) do |prod_type|
  json.extract! prod_type, :part_id, :own_id, :desc
  json.url prod_type_url(prod_type, format: :json)
end