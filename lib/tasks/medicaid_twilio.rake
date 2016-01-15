task :medicaid_twilio => :environment do

		invalid_phone_numbers = ["+18477672332"]
		sms_medicaid = MedicaidDataTwilio.where(completed: "true").where.not(phone_number: invalid_phone_numbers)

		sent_phone_numbers = 
		["+17737109009",
		"+16305233589",
		"+17739481018",
		"+17736198836",
		"+16307885727",
		"+12243928519",
		"+17734285044",
		"+17738173041",
		"+17089270666",
		"+18477085226",
		"+17735403674",
		"+17733298066",
		"+13122375062",
		"+17734304581",
		"+17737126517",
		"+17735672764",
		"+18153533018",
		"+17739345126",
		"+18155032853",
		"+16303130751",
		"+13123200369",
		"+17028837796",
		"+17732903186",
		"+17738927622",
		"+16304025451",
		"+17735175021",
		"+18155088569",
		"+17083784551",
		"+17086620031",
		"+17735107978",
		"+17084154655",
		"+17739308778",
		"+17734850782",
		"+18479463921",
		"+17087854850",
		"+17083149542",
		"+17085394588",
		"+17086916820",
		"+13125337804",
		"+17734472198",
		"+12242349274",
		"+17082681778",
		"+17735404246",
		"+13123860461",
		"+17086258743",
		"+18473448199",
		"+17734579918",
		"+17739880462",
		"+13122134792",
		"+17739877378",
		"+12242802602",
		"+18477672332",
		"+13122823144",
		"+17732400032",
		"+13125133558",
		"+13125550303",
		"+17083458346",
		"+13107667151",
		"+13126541111",
		"+17084779910",
		"+17736419044",
		"+17739328566",
		"+17739689009",
		"+17736459438",
		"+13126459438",
		"+17089836666",
		"+16308905928",
		"+18478097511",
		"+18477912848",
		"+17739143593",
		"+17738865622",
		"+13124785490",
		"+17737890343",
		"+17735741896",
		"+18153709552",
		"+16307819324",
		"+17735679878",
		"+17734548320",
		"+17735551000",
		"+17733124563",
		"+17735809545",
		"+13126612911"]

		phone_numbers = []
		sms_medicaid.each do |medicaid|
			# income = medicaid.monthly_gross_income.to_i
			# household_size = medicaid.household_size.to_i

			# if household_size > 0
			# 	snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => household_size })

			# 	if income < snap_eligibility.snap_gross_income
			# 		phone_number = medicaid.phone_number.strip
					if sent_phone_numbers.include?(phone_number)
					else
						phone_numbers.push(phone_number)
					end
			# 	end

			# end
		end

		puts "PHONE NUMBER COUNT = #{phone_numbers.count}"
		phone_numbers.uniq.each do |phone_number|
			puts "PHONE NUMBER - #{phone_number}"
		end

end



