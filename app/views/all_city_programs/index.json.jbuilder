json.array!(@all_city_programs) do |all_city_program|
  json.extract! all_city_program, :id
  json.url all_city_program_url(all_city_program, format: :json)
end
