json.array!(@medicare_cost_sharings) do |medicare_cost_sharing|
  json.extract! medicare_cost_sharing, :id, :household_size, :medicare_cost_sharing, :premium_only
  json.url medicare_cost_sharing_url(medicare_cost_sharing, format: :json)
end
