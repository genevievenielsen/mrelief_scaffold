task :all_city => :environment do

	# invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555"]
	valid_all_city = AllCityProgramDatum.all

	all_city_count = valid_all_city.count
	puts "All City Count #{all_city_count}"

	# INTEGERS
	variables = ["dependent_no", "medicare_household_size", "age", "monthly_gross_income", "thirty_day_net_income", "child_support", "ssi", "monthly_benefits", "ninety_day_gross_income", "annual_gross_income", "assets", "number_of_children"]
	variables.each do |variable|
		puts "#{variable}"
		values = valid_all_city.pluck("#{variable}") 
		value_average = (values.map(&:to_i).sum / values.size.to_f).round(2)
		puts "Average: #{value_average}"

		values.delete(nil)
		sorted = values.sort
		len = sorted.length 
		value_median = (sorted[(len - 1) / 2] + sorted[len / 2]).to_i / 2.0 
		puts "Median: #{value_median}"

		freq = values.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		value_mode = values.max_by { |v| freq[v] }
		puts "Mode: #{value_mode}"
  end
 
		pregnant = valid_all_city.where("pregnant_or_caring_for_child like ?", "%pregnant%").count
  	puts "pregnant : #{pregnant}"

  	pregnant_with_first_child = valid_all_city.where.not(pregnant_with_first_child: nil).count
  	puts "pregnant_with_first_child : #{pregnant_with_first_child}"

  	teen_parent = valid_all_city.where.not(teen_parent: nil).count
  	puts "teen_parent : #{teen_parent}"

  	child_in_school = valid_all_city.where.not(child_in_school: nil).count
  	puts "child_in_school : #{child_in_school}"

  	care_for_child = valid_all_city.where("pregnant_or_caring_for_child like ?", "%care_for_child%").count
  	puts "care_for_child : #{care_for_child}"

  	no_children = valid_all_city.where("pregnant_or_caring_for_child like ?", "%no_children%").count
  	puts "no_children : #{no_children}"

  # YES NO
  variables = ["enrolled_in_education", "citizen", "name_on_lease", "next_month_rent", "tanif_sixty_months", "anticipate_other_income",  "snap_eligibility_status", "all_kids_eligibility_status", "rta_eligibility_status", "medicaid_eligibility_status", "medicare_cost_sharing_eligibility_status", "rental_eligibility_status", "aabd_eligibility_status", "tanf_eligibility_status",  "work_status"]
  variables.each do |variable|
  	puts "#{variable}"
  	yes = valid_all_city.where("#{variable}" => "yes").count
  	puts "YES : #{yes}"
  	no = valid_all_city.where("#{variable}" => "no").count
  	puts "NO : #{no}"
  	maybe = valid_all_city.where("#{variable}" => "maybe").count
  	puts "maybe : #{maybe}"
  end


  # FREQUENCY
  variables = ["zipcode", "user_location", "rental_status", "student_status", "child_health_insurance_state", "disabled_status"]
  variables.each do |variable|
  	variable = variable.tr(',', '').strip
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