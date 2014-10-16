json.array!(@laf_centers) do |laf_center|
  json.extract! laf_center, :id, :zipcode, :city, :center, :address, :contact, :telephone, :spanish
  json.url laf_center_url(laf_center, format: :json)
end
