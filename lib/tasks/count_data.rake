task :count_data => :environment do

  # Web Count

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

  web_count = aabd_count + all_kids_count + child_care_voucher_count + early_head_start_count + head_start_count
  puts "Web Count: #{web_count}"



  # Twilio Count
  puts "####"
  medicaid_count_twilio = MedicaidDataTwilio.all.count
  puts "Medicaid Twilio: #{medicaid_count_twilio}"

  twilio_count = medicaid_count_twilio
  puts "Twilio Count: #{twilio_count}"

  puts "####"
  total_count = web_count + twilio_count
  puts "Total Count: #{total_count}"
end
