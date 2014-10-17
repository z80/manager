json.array!(@logs) do |log|
  json.extract! log, :msg
  json.url log_url(log, format: :json)
end