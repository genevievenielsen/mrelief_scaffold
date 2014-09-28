json.array!(@child_care_vouchers) do |child_care_voucher|
  json.extract! child_care_voucher, :id, :ccdf_dependent_no, :ccdf_eligible_children, :ccdf_gross_income
  json.url child_care_voucher_url(child_care_voucher, format: :json)
end
