task :early_childhood => :environment do

	require 'open-uri'
	require 'json'

	url = "https://data.cityofchicago.org/resource/ck29-hb9r.json"
	raw_data = open(url).read
	parsed_data = JSON.parse(raw_data)

	puts "This is the number of locations: #{parsed_data.count}"

	# head_start_childare_collaboration = []
	# head_start_preschool_childcare_collaboration = []
	# preschool_for_all_childcare_collaboration = []
	# prevention_initiative_home_visiting_0to2 = []
	# school_based_no_co_pay_full_day = []
	# school_based_no_co_pay_half_day = []
	# school_based_co_pay_full_day = []
	# school_based_co_pay_half_day = []
	# head_start_center_based_half_day_3to5 = []
	# early_head_start_childcare_collaboration = []
	# prevention_initiative_childcare_collaboration = []
	# early_head_start_home_visiting_0to2 = []
	# head_start_home_visting_3to5 = []
	# head_start_school_based_half_day_3to5 = []
	# head_start_school_based_full_day_3to5 = []

	ages_3_to_5 = []
	ages_0_3 = []

	parsed_data.each do |location|

		if location["ages_3_5"] == true
			ages_3_to_5.push(location)
		end

		if location["ages_0_3"] == true && location["zip"] == "60610"
			ages_0_3.push(location)
		end

		# if location["program_information"].include?("Head Start") && location["program_information"].exclude?("CPS Based") && location["weekday_availability"].include?("Full Day")
		# 	head_start_childare_collaboration.push(location)
		# end

		# if location["program_information"].include?("Head Start") && location["program_information"].exclude?("CPS Based") && location["weekday_availability"].include?("Full Day")
		# 	head_start_preschool_childcare_collaboration.push(location)
		# end

		# if location["program_information"].exclude?("Head Start") && location["program_information"].exclude?("CPS Based") && location["weekday_availability"].include?("Full Day")
		# 	preschool_for_all_childcare_collaboration.push(location)
		# end

		# if location["program_information"].include?("Home Visiting") && location["program_information"].exclude?("Head Start") && location["program_information"].exclude?("Early Head Start") #&& location["weekday_availability"].include?("Home Visiting")
		# 	prevention_initiative_home_visiting_0to2.push(location)
		# end

		# if location["program_information"].include?("CPS Based") && location["program_information"].include?(" Head Start") && location["weekday_availability"].include?("Full Day")
		# 	school_based_no_co_pay_full_day.push(location)
		# end

		# if location["program_information"].include?("CPS Based") || location["program_information"].include?("CPS Based, Head Start") && location["weekday_availability"].include?("Part Day")
		# 	school_based_no_co_pay_half_day.push(location)
		# end

		# if location["program_information"].include?("CPS Based") && location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Full Day")
		# 	school_based_co_pay_full_day.push(location)
		# end

		# if location["program_information"].include?("CPS Based") && location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Part Day")
		# 	school_based_co_pay_half_day.push(location)
		# end

		# if location["program_information"].include?("Head Start") && location["program_information"].exclude?("CPS Based") && location["weekday_availability"].include?("Full Day")
		# 	head_start_center_based_half_day_3to5.push(location)
		# end

		# if location["program_information"].include?("Early Head Start") && location["weekday_availability"].include?("Full Day")
		# 	early_head_start_childcare_collaboration.push(location)
		# end

		# if location["program_information"].include?("Community Based") && location["program_information"].exclude?("Head Start")&& location["program_information"].exclude?("Early Head Start") && location["weekday_availability"].include?("Full Day")
		# 	prevention_initiative_childcare_collaboration.push(location)
		# end

		# if location["program_information"].include?("Early Head Start") && location["program_information"].include?("Home Visiting") 
		# 	early_head_start_home_visiting_0to2.push(location)
		# end

		# if location["program_information"].include?("Head Start") && location["program_information"].include?("Home Visiting")
		# 	head_start_home_visting_3to5.push(location)
		# end

		# if location["program_information"].include?("CPS Based") && location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Part Day")
		# 	head_start_school_based_half_day_3to5.push(location)
		# end

		# if location["program_information"].include?("CPS Based") && location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Full Day")
		# 	head_start_school_based_full_day_3to5.push(location)
		# end

		# if location["weekday_availability"].include?(@user.preferred_frequency) unless @user.preferred_frequency == "No Preference"
		# end

		# if location["weekday_availability"].include?(@user.preferred_duration) unless @user.preferred_duration == "No Preference"
		# end

		# if location["languages_other_than_english"].include?(@user.bilingual_language) unless @user.bilingual == "no"
		# end

	end

	# puts "This is the count for Head Start - Childcare Collaboration: #{head_start_childare_collaboration.count}"
	# puts "This is the count for Head Start - PreSchool - Childcare Collaboration: #{head_start_childare_collaboration.count}"
	# puts "This is the count for PreSchool for All - Childcare Collaboration: #{preschool_for_all_childcare_collaboration.count}"
	# puts "This is the count for Prevention Initiative: #{prevention_initiative_home_visiting_0to2.count}"
	# puts "This is the count for School Based No Co-Pay Full Day: #{school_based_no_co_pay_full_day.count}"
	# puts "This is the count for School Based No Co-Pay Part Day: #{school_based_no_co_pay_half_day.count}"
	# puts "This is the count for School Based Co-Pay Full Day: #{school_based_co_pay_full_day.count}"
	# puts "This is the count for School Based Co-Pay Part Day: #{school_based_co_pay_half_day.count}"
	# puts "This is the count for Head Start Center Based Half Day: #{head_start_center_based_half_day_3to5.count}"
	# puts "This is the count for Early Head Start Childcare Collaboration: #{early_head_start_childcare_collaboration.count}"
	# puts "This is the count for Prevention Initiative Childcare Collaboration: #{prevention_initiative_childcare_collaboration.count}"
	# puts "This is the count for Early Head Start Home Visiting: #{early_head_start_home_visiting_0to2.count}"
	# puts "This is the count for Head Start Home Visiting: #{head_start_home_visting_3to5.count}"
	# puts "This is the count for Head Start School Based Half Day: #{head_start_school_based_half_day_3to5.count}"
	# puts "This is the count for Head Start School Based Full Day: #{head_start_school_based_full_day_3to5.count}"
	
	puts "Zero to Three: #{ages_0_3.count}"
	puts "Three to Five: #{ages_3_to_5.count}"

	
end