json.array!(@image_to_samples) do |image_to_sample|
  json.extract! image_to_sample, :image_id, :sample_id
  json.url image_to_sample_url(image_to_sample, format: :json)
end