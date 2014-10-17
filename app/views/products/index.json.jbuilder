json.array!(@products) do |product|
  json.extract! product, :prod_type_id, :serial_number, :desc, :status
  json.url product_url(product, format: :json)
end