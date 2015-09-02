task :early_childhood_count_data => :environment do

	# Totals 
	all_web = EarlyLearningData.all.count
	puts "All Web: #{all_web}"

	all_sms = EarlyLearningDataTwilio.all.count
	puts "All Web: #{all_sms}"

	total = all_web + all_sms
	puts "Early Learning Total: #{total}"

	# Totals after launch
	invalid_phone_numbers = ["5555555555", "7777777777", "3125555555"]
	all_web_after_launch = EarlyLearningData.where(complete: true).where.not(phone_number: invalid_phone_numbers).where("created_at > ?", "2015-08-08")
	puts "All Web: #{all_web_after_launch.count}"

	all_sms_after_launch = EarlyLearningDataTwilio.where("created_at > ?", "2015-08-08").where(completed: true)
	puts "All SMS: #{all_sms_after_launch.count}"

	total_after_launch = all_web_after_launch.count + all_sms_after_launch.count
	puts "Early Learning Total: #{total_after_launch}"

	# Total Spanish
	web_spanish = all_web_after_launch.where(spanish: true).count
	puts "Web Spanish: #{web_spanish}"
	sms_spanish = all_sms_after_launch.where(spanish: true).count
	puts "SMS Spanish: #{sms_spanish}"

	# Total data sharing
	web_data_sharing = all_web_after_launch.where(data_sharing: true)
	puts "Web Data Sharing: #{web_data_sharing.count}"
	sms_data_sharing = all_sms_after_launch.where(data_sharing: true)
	puts "SMS Data Sharing: #{sms_data_sharing.count}"



	# Child Age Question
	puts "WEB AGES"
	web_three_and_under = web_data_sharing.pluck(:three_and_under).count(true)
	puts "Three and under: #{web_three_and_under}"
	web_three_to_five = web_data_sharing.pluck(:three_to_five).count(true)
	puts "Three to Five: #{web_three_to_five}"
	web_six_to_twelve = web_data_sharing.pluck(:six_to_twelve).count(true)
	puts "Six to twelve: #{web_six_to_twelve}"
	web_pregnant = web_data_sharing.pluck(:pregnant).count(true)
	puts "Pregant: #{web_pregnant}"
	web_no_children = web_data_sharing.pluck(:no_children).count(true)
	puts "No children: #{web_no_children}"

	puts "SMS AGES"
	sms_three_and_under = sms_data_sharing.pluck(:three_and_under).count(true)
	puts "Three and under: #{sms_three_and_under}"
	sms_three_to_five = sms_data_sharing.pluck(:three_to_five).count(true)
	puts "Three to Five: #{sms_three_to_five}"
	sms_six_to_twelve = sms_data_sharing.pluck(:six_to_twelve).count(true)
	puts "Six to twelve: #{sms_six_to_twelve}"
	sms_pregnant = sms_data_sharing.pluck(:pregnant).count(true)
	puts "Pregant: #{sms_pregnant}"
	sms_no_children = sms_data_sharing.pluck(:no_children).count(true)
	puts "No children: #{sms_no_children}"


	# Household Size Question
	puts "WEB HOUSEHOLD SIZE"
	household_sizes = web_data_sharing.pluck(:household_size) 
	household_size_average = (household_sizes.sum / household_sizes.size.to_f).round(2)
	puts "Average: #{household_size_average}"

	sorted = household_sizes.sort
	len = sorted.length 
	household_size_median = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0 
	puts "Median: #{household_size_median}"

	freq = household_sizes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	household_size_mode = household_sizes.max_by { |v| freq[v] }
	puts "Mode: #{household_size_mode}"

	puts "SMS HOUSEHOLD SIZE"
	household_sizes = sms_data_sharing.pluck(:household_size) 
	household_size_average = (household_sizes.sum / household_sizes.size.to_f).round(2)
	puts "Average: #{household_size_average}"

	sorted = household_sizes.sort
	len = sorted.length 
	household_size_median = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0 
	puts "Median: #{household_size_median}"

	freq = household_sizes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	household_size_mode = household_sizes.max_by { |v| freq[v] }
	puts "Mode: #{household_size_mode}"


	# Income Question
	puts "WEB INCOME TYPES"
	income_type = web_data_sharing.pluck(:income_type) 
	freq = income_type.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	freq.each do |income_type, frequency|
		if income_type.present? 
			puts "#{income_type}: #{frequency}" 
		end
	end 
	puts "WEB INCOME"
	gross_monthly_incomes = web_data_sharing.pluck(:gross_monthly_income) 
	gross_monthly_income_average = (gross_monthly_incomes.sum / gross_monthly_incomes.size.to_f).round(2)
	puts "Average: #{gross_monthly_income_average}"

	sorted = gross_monthly_incomes.sort
	len = sorted.length 
	gross_monthly_income_median = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0 
	puts "Median: #{gross_monthly_income_median}"

	freq = gross_monthly_incomes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	gross_monthly_income_mode = gross_monthly_incomes.max_by { |v| freq[v] }
	puts "Mode: #{gross_monthly_income_mode}"

	puts "SMS INCOME"
	gross_monthly_incomes = sms_data_sharing.pluck(:gross_monthly_income) 
	gross_monthly_income_average = (gross_monthly_incomes.sum / gross_monthly_incomes.size.to_f).round(2)
	puts "Average: #{gross_monthly_income_average}"

	sorted = gross_monthly_incomes.sort
	len = sorted.length 
	gross_monthly_income_median = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0 
	puts "Median: #{gross_monthly_income_median}"

	freq = gross_monthly_incomes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	gross_monthly_income_mode = gross_monthly_incomes.max_by { |v| freq[v] }
	puts "Mode: #{gross_monthly_income_mode}"


	# Categorical Eligibility Question
	puts "WEB CATEGORICAL ELIGIBILITY"
	web_foster_parent = web_data_sharing.pluck(:foster_parent).count(true)
	puts "Foster Parent: #{web_foster_parent}"
	web_ssi = web_data_sharing.pluck(:ssi).count(true)
	puts "SSI: #{web_ssi}"
	web_tanf = web_data_sharing.pluck(:tanf).count(true)
	puts "TANF: #{web_tanf}"
	web_teen_parent = web_data_sharing.pluck(:teen_parent).count(true)
	puts "Teen Parent: #{web_teen_parent}"
	web_special_needs = web_data_sharing.pluck(:special_needs).count(true)
	puts "Special Needs: #{web_special_needs}"
	web_none_of_the_above = web_data_sharing.pluck(:none_of_the_above).count(true)
	puts "None of the Above: #{web_none_of_the_above}"


	# Homeless Question
	puts "WEB HOMELESSNESS QUESTION"
	web_homeless_fixed_residence = web_data_sharing.pluck(:homeless_fixed_residence).count(true)
	puts "Homeless lack fixed residence: #{web_homeless_fixed_residence}"
	web_homeless_hotels  = web_data_sharing.pluck(:homeless_hotels).count(true)
	puts "Homeless hotels : #{web_homeless_hotels}"
	web_homeless_shelters = web_data_sharing.pluck(:homeless_shelters).count(true)
	puts "Homeless Shelters: #{web_homeless_shelters}"
	web_not_homeless = web_data_sharing.pluck(:not_homeless).count(true)
	puts "Not Homeless: #{web_not_homeless}"


	# Employed Question
	puts "EMPLOYED QUESTION"
	web_employed = web_data_sharing.pluck(:employed).count("yes")
	puts "Employed : #{web_employed}"


	# Zipcode Question
	web_zipcodes = web_data_sharing.pluck(:zipcode) 
	sms_zipcodes = sms_data_sharing.pluck(:zipcode) 
	total_zipcodes = web_zipcodes + sms_zipcodes
	freq = total_zipcodes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	puts "ZIPCODES"
	freq.each do |zipcode, frequency| 
		puts "#{zipcode}: #{frequency}" 
	end 


	# Other Zipcode Question
	puts "OTHER ZIPCODE QUESTION"
	web_other_zipcode = web_data_sharing.pluck(:other_zipcode).count("yes")
	puts "Other Zipcode : #{web_other_zipcode}"


	# Preferred Zipcode
	web_preferred_zipcodes = web_data_sharing.pluck(:preferred_zipcode) 
	freq = web_preferred_zipcodes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	puts "PREFERRED ZIPCODES"
	freq.each do |zipcode, frequency|
		if zipcode.present? 
			puts "#{zipcode}: #{frequency}" 
		end
	end 


	# Preference Question
	puts "PREFERENCE QUESTION"
	web_half_day = web_data_sharing.pluck(:half_day).count(true)
	puts "Half Day: #{web_half_day}"
	web_full_day = web_data_sharing.pluck(:full_day).count(true)
	puts "full_day: #{web_full_day}"
	web_part_week = web_data_sharing.pluck(:part_week).count(true)
	puts "part_week: #{web_part_week}"
	web_full_week = web_data_sharing.pluck(:full_week).count(true)
	puts "Full Week: #{web_full_week}"
	web_home_visiting = web_data_sharing.pluck(:home_visiting).count(true)
	puts "Home Visiting: #{web_home_visiting}"
	web_no_duration_preference = web_data_sharing.pluck(:no_duration_preference).count(true)
	puts "No Duration Preference: #{web_no_duration_preference}"


	# Bilingual Instruction
	puts "BILINGUAL QUESTION"
	web_bilingual = web_data_sharing.pluck(:bilingual).count("yes")
	puts "Bilingual : #{web_bilingual}"


	# Bilingual Language
	web_bilingual_languages = web_data_sharing.pluck(:bilingual_language) 
	freq = web_bilingual_languages.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	puts "BILINGUAL LANGUAGES"
	freq.each do |language, frequency|
		if language.present? 
			puts "#{language}: #{frequency}" 
		end
	end 

	puts "OUTCOMES"
	web_ccap_eligible = web_data_sharing.pluck(:ccap_eligible).count(true)
	puts "CCAP Eligible: #{web_ccap_eligible}"


	web_head_start_childcare_collaboration = web_data_sharing.pluck(:head_start_childcare_collaboration).count(true)
	puts "head_start_childcare_collaboration : #{web_head_start_childcare_collaboration}"

	web_head_start_preschool_childcare_collaboration = web_data_sharing.pluck(:head_start_preschool_childcare_collaboration).count(true)
	puts "head_start_preschool_childcare_collaboration : #{web_head_start_preschool_childcare_collaboration}"

	web_preschool_for_all_childcare_collaboration = web_data_sharing.pluck(:preschool_for_all_childcare_collaboration).count(true)
	puts "preschool_for_all_childcare_collaboration : #{web_preschool_for_all_childcare_collaboration}"

  web_prevention_initiative_home_visiting_0to2  = web_data_sharing.pluck(:prevention_initiative_home_visiting_0to2 ).count(true)
  puts "prevention_initiative_home_visiting_0to2  : #{web_prevention_initiative_home_visiting_0to2 }"

  web_school_based_no_co_pay_full_day  = web_data_sharing.pluck(:school_based_no_co_pay_full_day).count(true)
  puts "school_based_no_co_pay_full_day  : #{web_school_based_no_co_pay_full_day }"

  web_school_based_no_co_pay_half_day = web_data_sharing.pluck(:school_based_no_co_pay_half_day).count(true)
  puts "school_based_no_co_pay_half_day : #{web_school_based_no_co_pay_half_day}"

  web_school_based_co_pay_full_day = web_data_sharing.pluck(:school_based_co_pay_full_day).count(true)
  puts "school_based_co_pay_full_day : #{web_school_based_co_pay_full_day}"

  web_school_based_co_pay_half_day = web_data_sharing.pluck(:school_based_co_pay_half_day).count(true)
  puts "school_based_co_pay_half_day : #{web_school_based_co_pay_half_day}"

	web_head_start_center_based_half_day_3to5 = web_data_sharing.pluck(:head_start_center_based_half_day_3to5).count(true)
	puts "head_start_center_based_half_day_3to5 : #{web_head_start_center_based_half_day_3to5}"
	
	web_early_head_start_childcare_collaboration = web_data_sharing.pluck(:early_head_start_childcare_collaboration).count(true)
	puts "early_head_start_childcare_collaboration : #{web_early_head_start_childcare_collaboration}"

	web_prevention_initiative_childcare_collaboration = web_data_sharing.pluck(:prevention_initiative_childcare_collaboration).count(true)
	puts "prevention_initiative_childcare_collaboration : #{web_prevention_initiative_childcare_collaboration}"

	web_early_head_start_home_visiting_0to2 = web_data_sharing.pluck(:early_head_start_home_visiting_0to2).count(true)
	puts "early_head_start_home_visiting_0to2 : #{web_early_head_start_home_visiting_0to2}"

	web_head_start_home_visting_3to5 = web_data_sharing.pluck(:head_start_home_visting_3to5).count(true)
	puts "head_start_home_visting_3to5 : #{web_head_start_home_visting_3to5}"
	
	web_head_start_school_based_half_day_3to5 = web_data_sharing.pluck(:head_start_school_based_half_day_3to5).count(true)
	puts "head_start_school_based_half_day_3to5 : #{web_head_start_school_based_half_day_3to5}"

	web_head_start_school_based_full_day_3to5 = web_data_sharing.pluck(:head_start_school_based_full_day_3to5).count(true)
	puts "head_start_school_based_full_day_3to5 : #{web_head_start_school_based_full_day_3to5}"
       
	           
	puts "ELIGIBLE COUNT"
	eligible_counts = web_data_sharing.pluck(:eligible_count).map(&:to_i)
	eligible_count_average = (eligible_counts.sum / eligible_counts.size.to_f).round(2)
	puts "Average: #{eligible_count_average}"

	sorted = eligible_counts.sort
	len = sorted.length 
	eligible_count_median = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0 
	puts "Median: #{eligible_count_median}"

	freq = eligible_counts.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	eligible_count_mode = eligible_counts.max_by { |v| freq[v] }
	puts "Mode: #{eligible_count_mode}"     
	              
	     
	  
	
	       
	             
	     
	     







end