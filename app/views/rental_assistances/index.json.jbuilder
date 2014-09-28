json.array!(@rental_assistances) do |rental_assistance|
  json.extract! rental_assistance, :id, :rental_dependent_no, :rental_gross_income, :rental_status
  json.url rental_assistance_url(rental_assistance, format: :json)
end
