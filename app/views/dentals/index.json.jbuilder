json.array!(@dentals) do |dental|
  json.extract! dental, :id, :dental_gross_income, :dental_household_size
  json.url dental_url(dental, format: :json)
end
