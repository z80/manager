json.array!(@items) do |item|
  json.extract! item, :supplierId, :internalId, :desc, :orderLink, :contractId, :integer, :deliverAddr, :status, :userPlaced, :userResp, :setSz, :setsCnt, :unitPrice, :unitPrice, :comment
  json.url item_url(item, format: :json)
end