task :early_childhood_zipcodes => :environment do

	require 'open-uri'
	require 'json'

	url = "https://data.cityofchicago.org/resource/ck29-hb9r.json"
	raw_data = open(url).read
	parsed_data = JSON.parse(raw_data)


	ChicagoEligibleZipcode.all.pluck(:zipcode).each do |zip|
		zip_counter = 0
		duration_counter = 0
		parsed_data.each do |location|
			
			if location["zip"].include?(zip.to_s)
				zip_counter += 1
				if location["weekday_availability"].include?("Full Day")
					duration_counter += 1 
				end
			end
		end

		# puts "#{zip}: #{zip_counter} - Full Day: #{duration_counter}"
		puts "#{duration_counter}"
	end

	counter = 0
	parsed_data.each do |location|
		if location["weekday_availability"].include?("Full Day")
			counter += 1
		end
	end

	puts "Full Day Programs #{counter}"

end