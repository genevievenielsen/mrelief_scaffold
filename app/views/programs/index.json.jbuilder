json.array!(@programs) do |program|
  json.extract! program, :id, :name, :category, :url, :description, :location
  json.url program_url(program, format: :json)
end
