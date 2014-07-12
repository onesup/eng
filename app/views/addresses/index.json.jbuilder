json.array!(@addresses) do |address|
  json.extract! address, :id, :addr1, :addr2, :addr3, :addr4, :zip
end
