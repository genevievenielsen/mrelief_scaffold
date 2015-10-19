task :rental => :environment do

	invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555"]
	valid_rental_assistance = RentalAssistanceData.where.not(phone_number: invalid_phone_numbers)

	rental_count = valid_rental_assistance.count
	puts "Rental Count #{rental_count}"

	eligible_count = valid_rental_assistance.where(rental_eligibility_status: "yes").count
	puts "Eligible Count #{eligible_count}"

	ineligible_count = valid_rental_assistance.where(rental_eligibility_status: "no").count
	puts "Ineligible Count #{ineligible_count}"


	puts "NAME ON LEASE"
	lease = valid_rental_assistance.where(name_on_lease: "yes").count
	puts "Name on Lease: #{lease}"

	no_lease = valid_rental_assistance.where(name_on_lease: "no").count
	puts "No Lease: #{no_lease}"


	puts "NEXT MONTH RENT"
	next_rent = valid_rental_assistance.where(next_month_rent: "yes").count
	puts "Next Rent: #{next_rent}"

	no_next_rent = valid_rental_assistance.where(next_month_rent: "no").count
	puts "No Next Rent: #{no_next_rent}"


	puts "INCOME"
	incomes = valid_rental_assistance.pluck(:ninety_day_gross_income) 
	income_average = (incomes.map(&:to_i).sum / incomes.size.to_f).round(2)
	puts "Average: #{income_average}"

	sorted = incomes.sort
	len = sorted.length 
	income_median = (sorted[(len - 1) / 2] + sorted[len / 2]).to_i  / 2.0 
	puts "Median: #{income_median}"

	freq = incomes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	income_mode = incomes.max_by { |v| freq[v] }
	puts "Mode: #{income_mode}"



	puts "HOUSEHOLD SIZE"
	household_sizes = valid_rental_assistance.pluck(:dependent_no) 
	household_size_average = (household_sizes.map(&:to_i).sum / household_sizes.size.to_f).round(2)
	puts "Average: #{household_size_average}"

	sorted = household_sizes.sort
	len = sorted.length 
	household_size_median = (sorted[(len - 1) / 2] + sorted[len / 2]).to_i / 2.0 
	puts "Median: #{household_size_median}"

	freq = household_sizes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	household_size_mode = household_sizes.max_by { |v| freq[v] }
	puts "Mode: #{household_size_mode}"


	puts "RENTAL STATUS"
	statuses = valid_rental_assistance.pluck(:rental_status) 
	freq = statuses.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	freq.sort_by {|h, v| v}.reverse.each do |status, frequency| 
		puts "#{status}: #{frequency}" 
	end 


	puts "ZIPCODES"
	zipcodes = valid_rental_assistance.pluck(:zipcode) 
	freq = zipcodes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	freq.sort_by {|h, v| v}.reverse.each do |zipcode, frequency| 
		puts "#{zipcode}: #{frequency}" 
	end


	puts "LOCATIONS"
	locations = valid_rental_assistance.pluck(:user_location) 
	freq = locations.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	freq.sort_by {|h, v| v}.reverse.each do |location, frequency| 
		puts "#{location}: #{frequency}" 
	end


	puts "WEB PHONE NUMBER"  
	valid_rental_assistance.pluck(:phone_number).uniq.each do |phone_number|
		puts phone_number
	end

end