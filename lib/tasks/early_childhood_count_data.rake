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
	puts "All Web: #{all_web_after_launch}"

	all_sms_after_launch = EarlyLearningDataTwilio.where("created_at > ?", "2015-08-08").count
	puts "All Web: #{all_sms_after_launch}"

	total_after_launch = all_web_after_launch + all_sms_after_launch
	puts "Early Learning Total: #{total_after_launch}"

	# Total data sharing
	web_data_sharing = all_web_after_launch.where(data_sharing: true).count

end