task :snap_web => :environment do

		invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555", "777-777-7777", "8477672332", "8888888888", "312-555-5555"]

		snap_ineligible = SnapEligibilityData.where.not(phone_number: invalid_phone_numbers).where(snap_eligibility_status: "no")
		all_city_ineligible = AllCityProgramDatum.where.not(phone_number: invalid_phone_numbers).where(snap_eligibility_status: "no")

		puts "WEB INELIGIBLE"
		phone_numbers = []
		snap_ineligible.each do |snap|
			phone_numbers.push(snap.phone_number.strip)
		end

		puts "ALL CITY PROGRAM WEB ELIGIBLE"
		all_city_ineligible.each do |snap|
			phone_numbers.push(snap.phone_number.strip)
		end


		phone_numbers.uniq.each do |phone_number|
			puts "PHONE NUMBER - #{phone_number}"
		end

end