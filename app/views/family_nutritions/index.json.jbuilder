json.array!(@family_nutritions) do |family_nutrition|
  json.extract! family_nutrition, :id, :nutrition_gross_income, :nutrition_household_size
  json.url family_nutrition_url(family_nutrition, format: :json)
end
