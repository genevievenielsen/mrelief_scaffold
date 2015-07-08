require 'open-uri'
require 'json'



 url = "https://data.cityofchicago.org/resource/ck29-hb9r.json"
 raw_data = open(url).read
 parsed_data = JSON.parse(raw_data)

correct_zipcode_locations = []
counter = 0

parsed_data.each do |location|

	if location["zip"] == "60626"
		correct_zipcode_locations.push(location)
	end
end

puts "This is the count: #{correct_zipcode_locations.count}"
