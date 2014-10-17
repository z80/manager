json.array!(@subparts) do |subpart|
  json.extract! subpart, :contains_id, :belongs_id
  json.url subpart_url(subpart, format: :json)
end