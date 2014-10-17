json.array!(@product_statuses) do |product_status|
  json.extract! product_status, :status
  json.url product_status_url(product_status, format: :json)
end