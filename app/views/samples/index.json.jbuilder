json.array!(@samples) do |sample|
  json.extract! sample, :from, :desc, :received, :due, :user_placed, :user_resp
  json.url sample_url(sample, format: :json)
end