json.array!(@boxes) do |box|
  json.extract! box, :box_id, :desc
  json.url box_url(box, format: :json)
end