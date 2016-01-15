task :rta_twilio => :environment do

		invalid_phone_numbers = ["+18477672332"]

		sms_rta = RtaFreeRideDataTwilio.where(completed: true).where.not(phone_number: invalid_phone_numbers).where("created_at < ?", "2015-12-31")

		phone_numbers = []
		sms_rta.each do |rta|

			phone_number = rta.phone_number.strip
			if sent_phone_numbers.include?(phone_number)
			else
				phone_numbers.push(phone_number)
			end
	
		end

		puts "PHONE NUMBER COUNT = #{phone_numbers.count}"
		phone_numbers.uniq.each do |phone_number|
			puts "PHONE NUMBER - #{phone_number}"
		end

end
