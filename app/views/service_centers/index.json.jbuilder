json.array!(@service_centers) do |service_center|
  json.extract! service_center, :id, :name, :latitude, :longitude, :street, :city, :state, :zip, :phone, :organization
  json.url service_center_url(service_center, format: :json)
end
