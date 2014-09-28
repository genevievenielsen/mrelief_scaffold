json.array!(@auto_repair_assistances) do |auto_repair_assistance|
  json.extract! auto_repair_assistance, :id, :auto_household_size, :auto_gross_income
  json.url auto_repair_assistance_url(auto_repair_assistance, format: :json)
end
