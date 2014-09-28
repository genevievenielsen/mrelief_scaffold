json.array!(@visions) do |vision|
  json.extract! vision, :id, :vision_gross_income, :vision_household_size
  json.url vision_url(vision, format: :json)
end
