task :demographics => :environment do

#AGE
  #web
  snap_ages = SnapEligibilityData.all.pluck(:age)
  all_city_ages = AllCityProgramDatum.all.pluck(:age)
  rta_ages = RtaFreeRideData.all.pluck(:age)
  aabd_ages = AabdCashData.all.pluck(:age)

  #twilio
  snap_twilio_age = SnapEligibilityDataTwilio.all.pluck(:age)
  total_age = snap_ages + rta_ages + aabd_ages + all_city_ages + snap_twilio_age

  total_age_integer = []
  total_age.each do |age|
    total_age_integer.push(age.to_i)
  end


  average = total_age_integer.sum / total_age_integer.size.to_f


#HOUSEHOLD SIZE
  # web
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

  #Twilio
  medicaid_size_twilio = MedicaidDataTwilio.all.pluck(:household_size)
  medicare_twilio_size = MedicareCostSharingDataTwilio.all.pluck(:household_size)
  rta_twilio_size = RtaFreeRideDataTwilio.all.pluck(:dependent_no)
  snap_twilio_size = SnapEligibilityDataTwilio.all.pluck(:dependent_no)


  total_size = all_city_size + aabd_size  + all_kids_size + child_care_voucher_size + early_head_start_size + head_start_size + medicaid_size + medicare_size + rental_assistance_size + rta_free_ride_size + snap_size + tanf_size + wic_size + medicaid_size_twilio + medicare_twilio_size + rta_twilio_size + snap_twilio_size
  total_size_integer = []
  total_size.each do |size|
    total_size_integer.push(size.to_i)
  end

  total_size_clean = []
  total_size_integer.each do |size|
    if size <= 20
      total_size_clean.push(size.to_i)
    end
  end

  average = total_size_clean.sum / total_size_clean.size.to_f

#GROSS INCOME
  # web
    all_city_income = AllCityProgramDatum.all.pluck(:monthly_gross_income)
    all_kids_income = AllKidsData.all.pluck(:monthly_gross_income)
    child_care_voucher_income = ChildCareVoucherData.all.pluck(:gross_monthly_income)
    medicaid_income = MedicaidData.all.pluck(:monthly_gross_income)
    medicare_income = MedicareCostSharingData.all.pluck(:monthly_gross_income)
    snap_income = SnapEligibilityData.all.pluck(:monthly_gross_income)
    wic_income = WicData.all.pluck(:gross_monthly_income)

    #twilio
    medicaid_income_twilio = MedicaidDataTwilio.all.pluck(:monthly_gross_income)
    medicare_twilio_income = MedicareCostSharingDataTwilio.all.pluck(:monthly_gross_income)
    snap_twilio_income = SnapEligibilityDataTwilio.all.pluck(:monthly_gross_income)


    total_income = all_city_income  + all_kids_income + child_care_voucher_income +  medicaid_income + medicare_income + snap_income + wic_income + medicaid_income_twilio + medicare_twilio_income + snap_twilio_income
    total_income_integer = []
    total_income.each do |income|
      if income != nil
        total_income_integer.push(income.to_i)
      end
    end

    total_income_clean = []
    total_income_integer.each do |income|
      if income <= 10000
        total_income_clean.push(income.to_i)
      end
    end

    average = total_income_clean.sum / total_income_clean.size.to_f

end
