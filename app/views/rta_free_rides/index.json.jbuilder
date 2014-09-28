json.array!(@rta_free_rides) do |rta_free_ride|
  json.extract! rta_free_ride, :id, :rta_dependent_no, :rta_gross_income
  json.url rta_free_ride_url(rta_free_ride, format: :json)
end
