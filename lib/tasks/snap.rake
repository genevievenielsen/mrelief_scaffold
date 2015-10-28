task :snap => :environment do

		invalid_phone_numbers = ["5555555555", "7777777777", "3125555555", "555-555-5555", "8477672332", "8477672332 "]
		snap_web_eligible = SnapEligibilityData.where.not(phone_number: invalid_phone_numbers).where(snap_eligibility_status: "yes").last(5)
		snap_web_ineligible = SnapEligibilityData.where.not(phone_number: invalid_phone_numbers).where(snap_eligibility_status: "no").last(5)

		snap_web_eligible.each do |snap|
			puts "phone_number: #{snap.phone_number}"
			puts "dependent_no: #{snap.dependent_no}"
			puts "monthly_gross_income: #{snap.monthly_gross_income}"
			puts "age: #{snap.age}"
			puts "disabled_status: #{snap.disabled_status}"
			puts "zipcode: #{snap.zipcode}"
			puts "amount_in_account: #{snap.amount_in_account}"
			puts "snap_eligibility_status: #{snap.snap_eligibility_status}"
			puts "#3333"
		end

		snap_web_ineligible.each do |snap|
			puts "phone_number: #{snap.phone_number}"
			puts "dependent_no: #{snap.dependent_no}"
			puts "monthly_gross_income: #{snap.monthly_gross_income}"
			puts "age: #{snap.age}"
			puts "disabled_status: #{snap.disabled_status}"
			puts "zipcode: #{snap.zipcode}"
			puts "amount_in_account: #{snap.amount_in_account}"
			puts "snap_eligibility_status: #{snap.snap_eligibility_status}"
			puts "#3333"
		end

		invalid_phone_numbers = ["+18477672332"]
		snap_sms_eligible = SnapEligibilityDataTwilio.where(completed: true).where.not(phone_number: invalid_phone_numbers).where(snap_eligibility_status: "yes").last(5)

		puts "TEXT MESSAGING ELIGIBLE"
		snap_sms_eligible.each do |snap|
			puts "phone_number: #{snap.phone_number}"
			puts "dependent_no: #{snap.dependent_no}"
			puts "monthly_gross_income: #{snap.monthly_gross_income}"
			puts "age: #{snap.age}"
			puts "disabled: #{snap.	disabled}"
			puts "zipcode: #{snap.zipcode}"
			puts "snap_eligibility_status: #{snap.snap_eligibility_status}"
			puts "#3333"
		end

		snap_sms_ineligible = SnapEligibilityDataTwilio.where(completed: true).where.not(phone_number: invalid_phone_numbers).where(snap_eligibility_status: "no").last(5)

		puts "TEXT MESSAGING INELIGIBLE"
		snap_sms_ineligible.each do |snap|
			puts "phone_number: #{snap.phone_number}"
			puts "dependent_no: #{snap.dependent_no}"
			puts "monthly_gross_income: #{snap.monthly_gross_income}"
			puts "age: #{snap.age}"
			puts "disabled: #{snap.	disabled}"
			puts "zipcode: #{snap.zipcode}"
			puts "snap_eligibility_status: #{snap.snap_eligibility_status}"
			puts "#3333"
		end

end