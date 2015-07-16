task :geocode_zipcodes => :environment do

	ChicagoEligibleZipcode.all.each do |zipcode|

		zipcode_row = ChicagoEligibleZipcode.find_by(zipcode: zipcode.zipcode)

		zipcode_row.latitude = zipcode.zipcode.to_lat
		zipcode_row.longitude = zipcode.zipcode.to_lon
		zipcode_row.save
	end
end