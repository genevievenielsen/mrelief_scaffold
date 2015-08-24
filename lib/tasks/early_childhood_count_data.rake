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

	all_sms_after_launch = EarlyLearningDataTwilio.where("created_at > ?", "2015-08-08")
	puts "All SMS: #{all_sms_after_launch.count}"

	total_after_launch = all_web_after_launch.count + all_sms_after_launch.count
	puts "Early Learning Total: #{total_after_launch}"

	# Total data sharing
	web_data_sharing = all_web_after_launch.where(data_sharing: true).count
	puts "Web Data Sharing: #{web_data_sharing}"

	sms_data_sharing = all_sms_after_launch.where(data_sharing: true).count
	puts "Sms Data Sharing: #{sms_data_sharing}"

	# Total Spanish
	web_spanish = all_web_after_launch.where(spanish: true).count
	puts "Web Spanish: #{web_spanish}"

	sms_spanish = all_sms_after_launch.where(spanish: true).count
	puts "Sms Spanish: #{sms_spanish}"

end