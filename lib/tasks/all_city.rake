task :rental => :environment do

	invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555"]
	valid_all_city = AllCityProgramDatum.where.not(phone_number: invalid_phone_numbers)

	# INTEGERS
	variables = ["dependent_no", "medicare_household_size", "age", "monthly_gross_income", "thirty_day_net_income", "child_support", "ssi", "monthly_benefits", "ninety_day_gross_income", "annual_gross_income", "assets", "number_of_children"]
	variables.each do |variable|
		puts "#{variable}"
		values = valid_all_city.pluck("#{variable}") 
		value_average = (values.map(&:to_i).sum / values.size.to_f).round(2)
		puts "Average: #{value_average}"

		sorted = values.sort
		len = sorted.length 
		value_median = (sorted[(len - 1) / 2] + sorted[len / 2]).to_i / 2.0 
		puts "Median: #{value_median}"

		freq = values.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		value_mode = values.max_by { |v| freq[v] }
		puts "Mode: #{value_mode}"
  end

  # YES NO
  variables = ["enrolled_in_education", "citizen", "disabled_status", "name_on_lease", "rental_status", "pregnant", "child_health_insurance_state", "pregnant_or_caring_for_child", "relationship_to_child", "pregnant_with_first_child", "tanif_sixty_months", "anticipate_other_income", "teen_parent", "child_in_school", "snap_eligibility_status", "all_kids_eligibility_status", "rta_eligibility_status", "medicaid_eligibility_status", "medicare_cost_sharing_eligibility_status", "rental_eligibility_status", "aabd_eligibility_status", "tanf_eligibility_status", "next_month_rent", "work_status", "student_status"]
  variables.each do |variable|
  	puts "#{variable}"
  	yes = valid_all_city.where("#{variable}" => "yes").count
  	puts "YES : #{yes}"
  	no = valid_all_city.where("#{variable}" => "no").count
  	puts "NO : #{no}"
  end


  # FREQUENCY
  variables = ["zipcode", "user_location", "rental_status"]
  variables.each do |variable|
  	values = valid_all_city.pluck("#{variable}") 
  	freq = values.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  	freq.sort_by {|h, v| v}.reverse.each do |value, frequency| 
  		puts "#{value}: #{frequency}" 
  	end
  end

  puts "WEB PHONE NUMBER"  
  valid_all_city.pluck(:phone_number).uniq.each do |phone_number|
  	puts phone_number
  end

end