json.array!(@snap_eligibilities) do |snap_eligibility|
  json.extract! snap_eligibility, :id, :snap_dependent_no, :snap_gross_income
  json.url snap_eligibility_url(snap_eligibility, format: :json)
end
