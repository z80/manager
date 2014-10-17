json.array!(@parts) do |part|
  json.extract! part, :own_id, :third_id, :user_id, :cnt
  json.url part_url(part, format: :json)
end