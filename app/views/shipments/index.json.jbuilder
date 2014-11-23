json.array!(@shipments) do |shipment|
  json.extract! shipment, :contract_id, :desc
  json.url shipment_url(shipment, format: :json)
end