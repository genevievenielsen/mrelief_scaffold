json.array!(@snap_eligibility_seniors) do |snap_eligibility_senior|
  json.extract! snap_eligibility_senior, :id, :snap_dependent_no, :snap_gross_income
  json.url snap_eligibility_senior_url(snap_eligibility_senior, format: :json)
end
