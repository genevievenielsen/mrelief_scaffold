task :location => :environment do

	# ALL CITY
	all_web = AllCityProgramDatum.all.count
	puts "All Web: #{all_web}"

	invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555"]
	all_web_this_month = AllCityProgramDatum.where.not(phone_number: invalid_phone_numbers).where("created_at > ?", "2015-11-08")

	puts "All Web This Month: #{all_web_this_month}"

	# locations
	user_location = all_web_this_month.pluck(:user_location) 
	freq = user_location.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	freq.each do |user_location, frequency|
		if user_location.present? 
			puts "#{user_location}: #{frequency}" 
		end
	end


	# RENTAL ASSISTANCE
	all_web = RentalAssistanceData.all.count
	puts "All Web: #{all_web}"

	invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555"]
	all_web_this_month = RentalAssistanceData.where.not(phone_number: invalid_phone_numbers).where("created_at > ?", "2015-11-08")

	puts "All Web This Month: #{all_web_this_month}"

	# locations
	user_location = all_web_this_month.pluck(:user_location) 
	freq = user_location.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	freq.each do |user_location, frequency|
		if user_location.present? 
			puts "#{user_location}: #{frequency}" 
		end
	end  

	# FOOD STAMPS

	all_web = SnapEligibilityData.all.count
	puts "All Web: #{all_web}"

	invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555"]
	all_web_this_month = SnapEligibilityData.where.not(phone_number: invalid_phone_numbers).where("created_at > ?", "2015-11-08")

	puts "All Web This Month: #{all_web_this_month.count}"

	# locations
	user_location = all_web_this_month.pluck(:user_location) 
	freq = user_location.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	freq.each do |user_location, frequency|
		if user_location.present? 
			puts "#{user_location}: #{frequency}" 
		end
	end  

end