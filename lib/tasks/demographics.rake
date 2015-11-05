task :demographics => :environment do

#AGE
  puts "WEB"
  snap_ages = SnapEligibilityData.all.pluck(:age)
  all_city_ages = AllCityProgramDatum.all.pluck(:age)
  rta_ages = RtaFreeRideData.all.pluck(:age)
  aabd_ages = AabdCashData.all.pluck(:age)

  web_age = snap_ages + rta_ages + aabd_ages + all_city_ages
  web_age_integer = web_age.map(&:to_i)
  web_average = web_age_integer.sum / web_age_integer.size.to_f
  puts "Web age - #{web_average}"


  puts "TWILIO"
  twilio_age = SnapEligibilityDataTwilio.all.pluck(:age)
  twilio_age_integer = twilio_age.map(&:to_i)
  twilio_average = twilio_age_integer.sum / twilio_age_integer.size.to_f
  puts "twilio age - #{twilio_average}"

  total_age = snap_ages + rta_ages + aabd_ages + all_city_ages + twilio_age
  total_age_integer = total_age.map(&:to_i)
  average = total_age_integer.sum / total_age_integer.size.to_f
  puts "Total age - #{average}"


#HOUSEHOLD SIZE
  puts "WEB"
  all_city_size = AllCityProgramDatum.all.pluck(:dependent_no)
  aabd_size = AabdCashData.all.pluck(:household_size)
  all_kids_size = AllKidsData.all.pluck(:household_size)
  child_care_voucher_size = ChildCareVoucherData.all.pluck(:dependent_no)
  early_head_start_size = EarlyHeadStartData.all.pluck(:dependent_no)
  head_start_size = HeadStartData.all.pluck(:dependent_no)
  medicaid_size = MedicaidData.all.pluck(:household_size)
  medicare_size = MedicareCostSharingData.all.pluck(:household_size)
  rental_assistance_size = RentalAssistanceData.all.pluck(:dependent_no)
  rta_free_ride_size = RtaFreeRideData.all.pluck(:dependent_no)
  snap_size = SnapEligibilityData.all.pluck(:dependent_no)
  tanf_size = TanfData.all.pluck(:household_size)
  wic_size = WicData.all.pluck(:household_size)

  web_size = all_city_size + aabd_size  + all_kids_size + child_care_voucher_size + early_head_start_size + head_start_size + medicaid_size + medicare_size + rental_assistance_size + rta_free_ride_size + snap_size + tanf_size + wic_size
  web_size_integer = web_size.map(&:to_i)

  web_size_clean = []
  web_size_integer.each do |size|
    if size <= 20
      web_size_clean.push(size.to_i)
    end
  end

  web_average = web_size_clean.sum / web_size_clean.size.to_f
  puts "Web household size - #{web_average}"

  puts "TWILIO"
  medicaid_size_twilio = MedicaidDataTwilio.all.pluck(:household_size)
  medicare_twilio_size = MedicareCostSharingDataTwilio.all.pluck(:household_size)
  rta_twilio_size = RtaFreeRideDataTwilio.all.pluck(:dependent_no)
  snap_twilio_size = SnapEligibilityDataTwilio.all.pluck(:dependent_no)

  twilio_size = medicare_twilio_size + rta_twilio_size + snap_twilio_size
  twilio_size_integer = twilio_size.map(&:to_i)
  twilio_average = twilio_size_integer.sum / twilio_size_integer.size.to_f
  puts "twilio household size - #{twilio_average}"


  total_size = all_city_size + aabd_size  + all_kids_size + child_care_voucher_size + early_head_start_size + head_start_size + medicaid_size + medicare_size + rental_assistance_size + rta_free_ride_size + snap_size + tanf_size + wic_size + medicaid_size_twilio + medicare_twilio_size + rta_twilio_size + snap_twilio_size
  total_size_integer = total_size.map(&:to_i)

  total_size_clean = []
  total_size_integer.each do |size|
    if size <= 20
      total_size_clean.push(size.to_i)
    end
  end
  average = total_size_clean.sum / total_size_clean.size.to_f
  puts "Total household size - #{average}"

#GROSS INCOME
    puts "WEB"
    all_city_income = AllCityProgramDatum.all.pluck(:monthly_gross_income)
    all_kids_income = AllKidsData.all.pluck(:monthly_gross_income)
    child_care_voucher_income = ChildCareVoucherData.all.pluck(:gross_monthly_income)
    medicaid_income = MedicaidData.all.pluck(:monthly_gross_income)
    medicare_income = MedicareCostSharingData.all.pluck(:monthly_gross_income)
    snap_income = SnapEligibilityData.all.pluck(:monthly_gross_income)
    wic_income = WicData.all.pluck(:gross_monthly_income)

    web_income = all_city_income  + all_kids_income + child_care_voucher_income +  medicaid_income + medicare_income + snap_income + wic_income 
    web_income_integer = (web_income - [nil]).map(&:to_i)

    web_income_clean = []
    web_income_integer.each do |income|
      if income <= 10000
        web_income_clean.push(income.to_i)
      end
    end

    web_average = web_income_clean.sum / web_income_clean.size.to_f
    puts "Web income - #{web_average}"

    puts "TWILIO"
    medicaid_income_twilio = MedicaidDataTwilio.all.pluck(:monthly_gross_income)
    medicare_twilio_income = MedicareCostSharingDataTwilio.all.pluck(:monthly_gross_income)
    snap_twilio_income = SnapEligibilityDataTwilio.all.pluck(:monthly_gross_income)

    twilio_income = medicaid_income_twilio + medicare_twilio_income + snap_twilio_income
    twilio_income_integer = (twilio_income - [nil]).map(&:to_i)

    twilio_income_clean = []
    twilio_income_integer.each do |income|
      if income <= 10000
        twilio_income_clean.push(income.to_i)
      end
    end

    twilio_average = twilio_income_clean.sum / twilio_income_clean.size.to_f
    puts "twilio income - #{twilio_average}"

    total_income = all_city_income  + all_kids_income + child_care_voucher_income +  medicaid_income + medicare_income + snap_income + wic_income + medicaid_income_twilio + medicare_twilio_income + snap_twilio_income
    total_income_integer = (total_income - [nil]).map(&:to_i)
   
    total_income_clean = []
    total_income_integer.each do |income|
      if income <= 10000
        total_income_clean.push(income.to_i)
      end
    end

    average = total_income_clean.sum / total_income_clean.size.to_f
    puts "Total income - #{average}"

end
