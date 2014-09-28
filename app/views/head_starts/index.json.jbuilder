json.array!(@head_starts) do |head_start|
  json.extract! head_start, :id, :hs_dependent_no, :hs_gross_income
  json.url head_start_url(head_start, format: :json)
end
