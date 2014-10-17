json.array!(@prod_subtypes) do |prod_subtype|
  json.extract! prod_subtype, :belongs_id, :contains_id
  json.url prod_subtype_url(prod_subtype, format: :json)
end