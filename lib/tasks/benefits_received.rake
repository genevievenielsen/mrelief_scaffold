task :benefits_received => :environment do

	# All people who completed the all city programs form in the King Center and were eligible for food stamps
	snap_eligible_phone_numbers = []
	AllCityProgramDatum.all.each do |all_city|
		if all_city.phone_number.present? && all_city.phone_number != "7777777777" && all_city.phone_number != "777777777" && all_city.snap_eligibility_status == "yes"
    	  snap_eligible_phone_numbers.push(all_city.phone_number)
    	end
	end

	puts "Number of phone numbers for food stamps: #{snap_eligible_phone_numbers.uniq.count}"
	snap_eligible_phone_numbers.uniq.each do |phone_number|
		# if phone_number.include?("-")
		# 	phone_number = phone_number.gsub!("-", "")	
		# end
		puts "#{phone_number}"
	end

	# All people who completed the all city programs form in the King Center and were eligible for rental assistance
	rental_eligible_phone_numbers = []
	AllCityProgramDatum.all.each do |all_city|
		if all_city.phone_number.present? && all_city.phone_number != "7777777777" && all_city.phone_number != "777777777" && all_city.rental_eligibility_status == "yes"
	   	  rental_eligible_phone_numbers.push(all_city.phone_number)
	   	end
	end

	puts "Number of phone numbers for rental assistance: #{rental_eligible_phone_numbers.uniq.count}"
	rental_eligible_phone_numbers.uniq.each do |phone_number|
		# if phone_number.include?("-")
		# 	phone_number = phone_number.gsub!("-", "")	
		# end
		puts "#{phone_number}"
	end


	# Duplicates between food stamps and rental assistance
	duplicates = snap_eligible_phone_numbers & rental_eligible_phone_numbers
	puts "Duplicates: #{duplicates.count}"
	duplicates.each do |duplicate|
		puts "#{duplicate}"
	end	

	# All people who completed the all city programs form in the King Center and were eligible for medicaid
	medicaid_eligible_phone_numbers = []
	AllCityProgramDatum.all.each do |all_city|
		if all_city.phone_number.present? && all_city.phone_number != "7777777777" && all_city.phone_number != "777777777" && all_city.medicaid_eligibility_status == "yes"
	   	  medicaid_eligible_phone_numbers.push(all_city.phone_number)
	   	end
	end

	puts "Number of phone numbers for medicaid: #{medicaid_eligible_phone_numbers.uniq.count}"
	medicaid_eligible_phone_numbers.uniq.each do |phone_number|
		# if phone_number.include?("-")
		# 	phone_number = phone_number.gsub!("-", "")	
		# end
		puts "#{phone_number}"
	end


	# Duplicates between food stamps and medicaid
	duplicates = snap_eligible_phone_numbers & medicaid_eligible_phone_numbers 
	puts "Snap and Medicaid Duplicates: #{duplicates.count}"
	duplicates.each do |duplicate|
		puts "#{duplicate}"
	end	

	# Duplicates between rental assistance and medicaid
	duplicates = rental_eligible_phone_numbers & medicaid_eligible_phone_numbers 
	puts "Rental and Medicaid Duplicates: #{duplicates.count}"
	duplicates.each do |duplicate|
		puts "#{duplicate}"
	end	
end