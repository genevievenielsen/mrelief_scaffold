task :forms_completed => :environment do

	puts "JANUARY"
	all_city_count = AllCityProgramDatum.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "All City Programs: #{all_city_count}"

  aabd_count = AabdCashData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Aabd: #{aabd_count}"

  all_kids_count = AllKidsData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "All Kids: #{all_kids_count}"

  child_care_voucher_count = ChildCareVoucherData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Child Care Voucher: #{child_care_voucher_count}"

  early_head_start_count = EarlyHeadStartData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Early Head Start: #{early_head_start_count}"

  head_start_count = HeadStartData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Head Start: #{head_start_count}"

  medicaid_count = MedicaidData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Medicaid: #{medicaid_count}"

  medicare_count = MedicareCostSharingData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Medicare: #{medicare_count}"

  rental_assistance_count = RentalAssistanceData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Rental Assistance: #{rental_assistance_count}"

  rta_free_ride_count = RtaFreeRideData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "RTA Ride Free: #{rta_free_ride_count}"

  snap_count = SnapEligibilityData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "SNAP: #{snap_count}"

  tanf_count = TanfData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "TANF: #{tanf_count}"

  wic_count = WicData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "WIC: #{wic_count}"

  early_learning_count = EarlyLearningData.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Early Learning: #{early_learning_count}"

  web_count = all_city_count + aabd_count + all_kids_count + child_care_voucher_count + early_head_start_count + head_start_count + medicaid_count + medicare_count +  rental_assistance_count + rta_free_ride_count + snap_count + tanf_count + wic_count + early_learning_count
  puts "Web Count: #{web_count}"

  puts "####"

  medicaid_count_twilio = MedicaidDataTwilio.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Medicaid Twilio: #{medicaid_count_twilio}"

  medicare_twilio_count = MedicareCostSharingDataTwilio.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "Medicare Twilio: #{medicare_twilio_count}"

  rta_free_ride_twilio_count = RtaFreeRideDataTwilio.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "RTA Ride Free Twilio: #{rta_free_ride_twilio_count}"

  early_learning_twilio_count = EarlyLearningDataTwilio.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "early_learning Twilio: #{early_learning_twilio_count}"

  snap_twilio_count = SnapEligibilityDataTwilio.where("created_at >= ?", "2016-01-04").where("created_at < ?", "2016-01-10").count
  puts "SNAP Twilio: #{snap_twilio_count}"

  twilio_count = medicaid_count_twilio + medicare_twilio_count + rta_free_ride_twilio_count + snap_twilio_count + early_learning_twilio_count
  puts "Twilio Count: #{twilio_count}"

  puts "####"

  total_count = web_count + twilio_count
  puts "Total Count: #{total_count}"

end