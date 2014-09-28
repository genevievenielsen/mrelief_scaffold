json.array!(@wics) do |wic|
  json.extract! wic, :id, :wic_household_size, :wic_gross_income
  json.url wic_url(wic, format: :json)
end
