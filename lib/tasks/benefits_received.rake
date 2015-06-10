task :benefits_received => :environment do

	# All people who completed the all city programs form in the King Center and were eligible for food stamps
	# snap_eligible_phone_numbers = []

	# AllCityProgramDatum.all.each do |all_city|
	# 	if all_city.phone_number.present? && all_city.phone_number != "7777777777" && all_city.phone_number != "777777777" && all_city.snap_eligibility_status == "yes"
 #    	  snap_eligible_phone_numbers.push(all_city.phone_number)
 #    	end
	# end

	# puts "Number of phone numbers for food stamps: #{snap_eligible_phone_numbers.uniq.count}"

	# snap_eligible_phone_numbers.uniq.each do |phone_number|
	# 	phone_number = phone_number.gsub!("-", "")	
	# 	puts "#{phone_number}"
	# end

	# All people who completed the all city programs form in the King Center and were eligible for rental assistance
	rental_eligible_phone_numbers = []

	AllCityProgramDatum.all.each do |all_city|
		if all_city.phone_number.present? && all_city.phone_number != "7777777777" && all_city.phone_number != "777777777" && all_city.rental_eligibility_status == "yes"
	   	  rental_eligible_phone_numbers.push(all_city.phone_number)
	   	end
	end

	puts "Number of phone numbers for rental assistance: #{rental_eligible_phone_numbers.uniq.count}"

	rental_eligible_phone_numbers.uniq.each do |phone_number|

		# phone_number = phone_number.gsub!("-", "")
		puts "#{phone_number}"
	end

		
end