task :count_data => :environment do

  # Web Count
  puts "####"

  all_city_count = AllCityProgramDatum.all.count
  puts "All City Programs: #{all_city_count}"

  aabd_count = AabdCashData.all.count
  puts "Aabd: #{aabd_count}"

  all_kids_count = AllKidsData.all.count
  puts "All Kids: #{all_kids_count}"

  child_care_voucher_count = ChildCareVoucherData.all.count
  puts "Child Care Voucher: #{child_care_voucher_count}"

  early_head_start_count = EarlyHeadStartData.all.count
  puts "Early Head Start: #{early_head_start_count}"

  head_start_count = HeadStartData.all.count
  puts "Head Start: #{head_start_count}"

  medicaid_count = MedicaidData.all.count
  puts "Medicaid: #{medicaid_count}"

  medicare_count = MedicareCostSharingData.all.count
  puts "Medicare: #{medicare_count}"

  rental_assistance_count = RentalAssistanceData.all.count
  puts "Rental Assistance: #{rental_assistance_count}"

  rta_free_ride_count = RtaFreeRideData.all.count
  puts "RTA Ride Free: #{rta_free_ride_count}"

  snap_count = SnapEligibilityData.all.count
  puts "SNAP: #{snap_count}"

  snap_disabled_count = SnapEligibilityData.where.not(disabled_status: "No").count
  puts "SNAP disability count: #{snap_disabled_count}"

  tanf_count = TanfData.all.count
  puts "TANF: #{tanf_count}"

  wic_count = WicData.all.count
  puts "WIC: #{wic_count}"

  early_learning_count = EarlyLearningData.all.count
  puts "Early Learning: #{early_learning_count}"

  web_count = all_city_count + aabd_count + all_kids_count + child_care_voucher_count + early_head_start_count + head_start_count + medicaid_count + medicare_count +  rental_assistance_count + rta_free_ride_count + snap_count + tanf_count + wic_count + early_learning_count
  puts "Web Count: #{web_count}"



  # Twilio Count
  puts "####"

  medicaid_count_twilio = MedicaidDataTwilio.all.count
  puts "Medicaid Twilio: #{medicaid_count_twilio}"

  medicare_twilio_count = MedicareCostSharingDataTwilio.all.count
  puts "Medicare Twilio: #{medicare_twilio_count}"

  rta_free_ride_twilio_count = RtaFreeRideDataTwilio.all.count
  puts "RTA Ride Free Twilio: #{rta_free_ride_twilio_count}"

  early_learning_twilio_count = EarlyLearningDataTwilio.all.count
  puts "early_learning Twilio: #{early_learning_twilio_count}"

  snap_twilio_count = SnapEligibilityDataTwilio.all.count
  puts "SNAP Twilio: #{snap_twilio_count}"

  snap_disabled_twilio_count = SnapEligibilityDataTwilio.where(disabled: "yes", disabled_receiving_payment: "yes").count
  puts "SNAP Twilio disability count: #{snap_disabled_twilio_count}"

  twilio_count = medicaid_count_twilio + medicare_twilio_count + rta_free_ride_twilio_count + snap_twilio_count + early_learning_twilio_count
  puts "Twilio Count: #{twilio_count}"

  puts "####"

  total_count = web_count + twilio_count
  puts "Total Count: #{total_count}"


  # Twilio conversion 
  medicaid_complete_count = MedicaidDataTwilio.where(completed: "true").count
  medicaid_conversion = medicaid_complete_count.to_f/medicaid_count_twilio.to_f
  puts "Medicaid Conversion #{medicaid_conversion}"

  medicare_complete_count = MedicareCostSharingDataTwilio.where(completed: "true").count
  medicare_conversion = medicare_complete_count.to_f/medicare_twilio_count.to_f
  puts "Medicare Conversion #{medicare_conversion}"

  rta_ride_free_complete_count = RtaFreeRideDataTwilio.where(completed: true).count
  rta_conversion = rta_ride_free_complete_count.to_f/rta_free_ride_twilio_count.to_f
  puts "RTA Conversion #{rta_conversion}"

  early_learning_complete_count = EarlyLearningDataTwilio.where(completed: true).count
  early_learning_conversion = early_learning_complete_count.to_f/early_learning_twilio_count.to_f
  puts "Early Learning Conversion #{early_learning_conversion}"

  snap_complete_count = SnapEligibilityDataTwilio.where(completed: true).count
  snap_conversion = snap_complete_count.to_f/snap_twilio_count.to_f
  puts "Snap Conversion #{snap_conversion}"

  conversion_average = (medicaid_conversion + medicare_conversion + rta_conversion + early_learning_conversion + snap_conversion) / 5

end
