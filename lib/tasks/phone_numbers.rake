task :phone_numbers => :environment do 

	invalid_phone_numbers = ["+18477672332"]
	phone_numbers = []

	sms_rta = RtaFreeRideDataTwilio.where(completed: true).where.not(phone_number: invalid_phone_numbers)

	sms_rta.each do |rta|
		phone_number = rta.phone_number.strip
			phone_numbers.push(phone_number)
	end


	sms_medicaid = MedicaidDataTwilio.where(completed: "true").where.not(phone_number: invalid_phone_numbers)
	sms_medicaid.each do |medicaid|
		phone_number = medicaid.phone_number.strip
		phone_numbers.push(phone_number)
	end


	sms_medicare = MedicareCostSharingDataTwilio.where(completed: "true").where.not(phone_number: invalid_phone_numbers)
	sms_medicare.each do |medicare|
		phone_number = medicare.phone_number.strip
		phone_numbers.push(phone_number)

	end

	sms_early_learning = EarlyLearningDataTwilio.where(completed: true, data_sharing: true).where.not(phone_number: invalid_phone_numbers)
	sms_early_learning.each do |early_learning|
		phone_number = early_learning.phone_number.strip
			phone_numbers.push(phone_number)
	end


	 puts "#{phone_numbers}"

end

