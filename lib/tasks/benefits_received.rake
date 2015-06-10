task :benefits_received => :environment do

	# All people who completed the all city programs form in the King Center and were eligible for food stamps
	snap_eligible_phone_numbers = []


	AllCityProgramDatum.all.each do |all_city|
		if all_city.created_at >= "January 14, 2015" && all_city.phone_number.present? && all_city.phone_number != "7777777777" && all_city.snap_eligibility_status == "yes"
    	  snap_eligible_phone_numbers.push(all_city.phone_number)
    	end
	end

	puts "Number of phone numbers: #{snap_eligible_phone_numbers.count}"

	snap_eligible_phone_numbers.each do |phone_number|
		puts "#{phone_number}"
	end
end