json.array!(@tanifs) do |tanif|
  json.extract! tanif, :id, :household_size, :earned_income, :tanif_payment, :max_income
  json.url tanif_url(tanif, format: :json)
end
