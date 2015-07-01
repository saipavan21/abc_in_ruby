json.array!(@riders) do |rider|
  json.extract! rider, :id, :email, :time, :sourcelat, :sourcelong, :deslat, :deslong
  json.url rider_url(rider, format: :json)
end
