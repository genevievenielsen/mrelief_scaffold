json.array!(@housing_assistances) do |housing_assistance|
  json.extract! housing_assistance, :id, :housing_dependent_no, :housing_gross_income
  json.url housing_assistance_url(housing_assistance, format: :json)
end
