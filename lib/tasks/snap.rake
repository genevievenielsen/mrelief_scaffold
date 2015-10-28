task :snap => :environment do

		invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555", "8477672332", "8477672332 "]
		snap_web = SnapEligibilityData.where.not(phone_number: invalid_phone_numbers).last(10)

		snap_web.each do |snap|
			puts "phone_number: #{snap.phone_number}"
			puts "dependent_no: #{snap.dependent_no}"
			puts "monthly_gross_income: #{snap.monthly_gross_income}"
			puts "age: #{snap.age}"
			puts "disabled_status: #{snap.disabled_status}"
			puts "zipcode: #{snap.zipcode}"
			puts "amount_in_account: #{snap.amount_in_account}"
			puts "#3333"
		end

		invalid_phone_numbers = ["+18477672332"]
		snap_sms = SnapEligibilityDataTwilio.where(completed: true).where.not(phone_number: invalid_phone_numbers).last(10)

		snap_sms.each do |snap|
			puts "phone_number: #{snap.phone_number}"
			puts "dependent_no: #{snap.dependent_no}"
			puts "monthly_gross_income: #{snap.monthly_gross_income}"
			puts "age: #{snap.age}"
			puts "disabled_status: #{snap.disabled_status}"
			puts "zipcode: #{snap.zipcode}"
			puts "amount_in_account: #{snap.amount_in_account}"
			puts "#3333"
		end

end