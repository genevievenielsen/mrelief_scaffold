task :early_childhood_count_data => :environment do

	# Totals 
	all_web = EarlyLearningData.all.count
	puts "All Web: #{all_web}"

	all_sms = EarlyLearningDataTwilio.all.count
	puts "All Web: #{all_sms}"

	total = all_web + all_sms
	puts "Early Learning Total: #{total}"

	# Totals after launch
	all_web_after_launch = EarlyLearningData.where(created_at: ).count
	puts "All Web: #{all_web_after_launch}"

	all_sms_after_launch = EarlyLearningDataTwilio.all.count
	puts "All Web: #{all_sms_after_launch}"

	total_after_launch = all_web_after_launch + all_sms_after_launch
	puts "Early Learning Total: #{total_after_launch}"

end