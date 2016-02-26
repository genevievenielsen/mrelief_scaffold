task :snap_twilio => :environment do

		invalid_phone_numbers = ["+18477672332"]

	
		snap_sms_ineligible = SnapEligibilityDataTwilio.where(completed: true).where.not(phone_number: invalid_phone_numbers).where.not(monthly_gross_income: "0")

		puts "TEXT MESSAGINGS"
		snap_sms_ineligible.each do |snap|
			puts "phone_number: #{snap.phone_number}"
		end

end