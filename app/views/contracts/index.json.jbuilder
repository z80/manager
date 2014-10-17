json.array!(@contracts) do |contract|
  json.extract! contract, :name, :desc, :ship_date, :shipped
  json.url contract_url(contract, format: :json)
end