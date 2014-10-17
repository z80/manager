json.array!(@part_insts) do |part_inst|
  json.extract! part_inst, :part_id, :box_id, :cnt
  json.url part_inst_url(part_inst, format: :json)
end