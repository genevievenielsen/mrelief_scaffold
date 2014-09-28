json.array!(@all_kids) do |all_kid|
  json.extract! all_kid, :id, :kids_household_size, :assist_gross_income, :share_gross_income, :premium_1_gross_income, :premium_2_gross_income
  json.url all_kid_url(all_kid, format: :json)
end
