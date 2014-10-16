json.array!(@organizations) do |organization|
  json.extract! organization, :id, :organization_id, :name, :url
  json.url organization_url(organization, format: :json)
end
