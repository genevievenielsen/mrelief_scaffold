json.array!(@early_head_starts) do |early_head_start|
  json.extract! early_head_start, :id, :ehs_dependent_no, :ehs_gross_income
  json.url early_head_start_url(early_head_start, format: :json)
end
