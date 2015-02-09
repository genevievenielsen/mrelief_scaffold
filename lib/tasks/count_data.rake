task :count_data => :environment do

  # Web Count

  all_city_count = AllCityProgramDatum.all.count
  puts "Aabd: #{all_city_count}"

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

  tanf_count = TanfData.all.count
  puts "TANF: #{tanf_count}"

  wic_count = WicData.all.count
  puts "WIC: #{wic_count}"

  web_count = all_city_count + aabd_count + all_kids_count + child_care_voucher_count + early_head_start_count + head_start_count + medicare_count +  rental_assistance_count
  + rta_free_ride_count + snap_count + tanf_count + wic_count
  puts "Web Count: #{web_count}"



  # Twilio Count
  puts "####"
  medicaid_count_twilio = MedicaidDataTwilio.all.count
  puts "Medicaid Twilio: #{medicaid_count_twilio}"

  medicare_twilio_count = MedicareCostSharingDataTwilio.all.count
  puts "Medicare Twilio: #{medicare_twilio_count}"

  rta_free_ride_twilio_count = RtaFreeRideDataTwilio.all.count
  puts "RTA Ride Free: #{rta_free_ride_twilio_count}"

  snap_twilio_count = SnapEligibilityDataTwilio.all.count
  puts "SNAP: #{snap_twilio_count}"

  twilio_count = medicaid_count_twilio + medicare_twilio_count + rta_free_ride_twilio_count + snap_twilio_count
  puts "Twilio Count: #{twilio_count}"

  puts "####"
  total_count = web_count + twilio_count
  puts "Total Count: #{total_count}"
end
