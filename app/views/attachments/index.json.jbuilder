json.array!(@attachments) do |attachment|
  json.extract! attachment, :desc
  json.url attachment_url(attachment, format: :json)
end