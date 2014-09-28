json.array!(@medicaids) do |medicaid|
  json.extract! medicaid, :id, :medicaid_household_size, :medicaid_gross_income
  json.url medicaid_url(medicaid, format: :json)
end
