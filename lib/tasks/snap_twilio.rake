task :snap_twilio => :environment do

		invalid_phone_numbers = ["+18477672332"]
		snap_sms_ineligible = SnapEligibilityDataTwilio.where(completed: true).where.not(phone_number: invalid_phone_numbers).where(snap_eligibility_status: "no")

		puts "TEXT MESSAGING INELIGIBLE"
		snap_sms_ineligible.each do |snap|
			puts "phone_number: #{snap.phone_number}"
		end

end