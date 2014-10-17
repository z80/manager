json.array!(@contract_items) do |contract_item|
  json.extract! contract_item, :contract_id, :prod_type_id, :product_id
  json.url contract_item_url(contract_item, format: :json)
end