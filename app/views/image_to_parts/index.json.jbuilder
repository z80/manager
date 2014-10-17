json.array!(@image_to_parts) do |image_to_part|
  json.extract! image_to_part, :image_id, :part_id
  json.url image_to_part_url(image_to_part, format: :json)
end