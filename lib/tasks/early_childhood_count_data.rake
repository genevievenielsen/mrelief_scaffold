task :early_childhood_count_data => :environment do

	# Totals 
	all_web = EarlyLearningData.all.count
	puts "All Web: #{all_web}"

	all_sms = EarlyLearningDataTwilio.all.count
	puts "All Web: #{all_sms}"

	total = all_web + all_sms
	puts "Early Learning Total: #{total}"

	# Totals after launch
	all_web_after_launch = EarlyLearningData.where("created_at > ?", "2015-08-08")
	puts "All Web: #{all_web_after_launch.count}"

	all_sms_after_launch = EarlyLearningDataTwilio.where("created_at > ?", "2015-08-08").where(completed: true)
	puts "All SMS: #{all_sms_after_launch.count}"

	total_after_launch = all_web_after_launch.count + all_sms_after_launch.count
	puts "Early Learning Total: #{total_after_launch}"

	# Total Spanish
	web_spanish = all_web_after_launch.where(spanish: true).count
	puts "Web Spanish: #{web_spanish}"
	sms_spanish = all_sms_after_launch.where(spanish: true).count
	puts "Sms Spanish: #{sms_spanish}"

	# Total data sharing
	web_data_sharing = all_web_after_launch.where(data_sharing: true)
	puts "Web Data Sharing: #{web_data_sharing.count}"

	sms_data_sharing = all_sms_after_launch.where(data_sharing: true)
	puts "SMS Data Sharing: #{sms_data_sharing.count}"

	# Zipcode
	web_zipcodes = web_data_sharing.pluck(:zipcode) 
	sms_zipcodes = sms_data_sharing.pluck(:zipcode) 
	total_zipcodes = web_zipcodes + sms_zipcodes
	freq = total_zipcodes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	puts "ZIPCODES"
	freq.each do |zipcode, frequency| 
		puts "#{zipcode}: #{frequency}" 
	end 

	# Preferred Zipcode
	web_preferred_zipcodes = web_data_sharing.pluck(:preferred_zipcode) 
	freq = web_preferred_zipcodes.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

	puts "PREFERRED ZIPCODES"
	freq.each do |zipcode, frequency|
		if zipcode.present? 
			puts "#{zipcode}: #{frequency}" 
		end
	end 

	# Child Age 
	three_and_under = web_data_sharing.pluck(:three_and_under)
	three_to_five = web_data_sharing.pluck(:three_to_five)
	six_to_twelve = web_data_sharing.pluck(:six_to_twelve)
	pregnant = web_data_sharing.pluck(:pregnant)
	no_children = web_data_sharing.pluck(:no_children)


end