task :click_through => :environment do

  snap_correct_dates = []
  SnapEligibilityData.all.each do |snap_data|
    if snap_data.created_at >= "February 2, 2015" && snap_data.created_at <= "March 12, 2015"
      snap_correct_dates.push(snap_data)
    end
  end

  snap_eligible = []
  snap_correct_dates.each do |snap_data|
    if snap_data.snap_eligibility_status == "yes"
      snap_eligible.push(snap_data)
    end
  end
  puts "snap_count: #{snap_eligible.count}"



  medicaid_correct_dates = []
  MedicaidData.all.each do |medicaid_data|
    if medicaid_data.created_at >= "February 2, 2015" && medicaid_data.created_at <= "March 12, 2015"
      medicaid_correct_dates.push(medicaid_data)
    end
  end

  medicaid_eligible = []
  medicaid_correct_dates.each do |medicaid_data|
    if medicaid_data.medicaid_eligibility_status == "yes"
      medicaid_eligible.push(medicaid_data)
    end
  end
  puts "medicaid_count: #{medicaid_eligible.count}"



  allkids_correct_dates = []
  AllKidsData.all.each do |allkids_data|
    if allkids_data.created_at >= "February 2, 2015" && allkids_data.created_at <= "March 12, 2015"
      allkids_correct_dates.push(allkids_data)
    end
  end

  allkids_eligible = []
  allkids_correct_dates.each do |allkids_data|
    if allkids_data.allkids_eligibility_status == "yes"
      allkids_eligible.push(allkids_data)
    end
  end
  puts "allkids_count: #{allkids_eligible.count}"



  allcity_correct_dates = []
  AllCityProgramDatum.all.each do |allcity_data|
    if allcity_data.created_at >= "February 2, 2015" && allcity_data.created_at <= "March 12, 2015"
      allcity_correct_dates.push(allcity_data)
    end
  end

  allcity_snap_eligible = []
  allcity_medicaid_eligible = []
  allcity_allkids_eligible = []

  allcity_correct_dates.each do |allcity_data|
    if allcity_data.snap_eligibility_status == "yes"
      allcity_snap_eligible.push(allcity_data)
    end
    if allcity_data.medicaid_eligibility_status == "yes"
      allcity_medicaid_eligible.push(allcity_data)
    end
    if allcity_data.all_kids_eligibility_status == "yes"
      allcity_allkids_eligible.push(allcity_data)
    end
  end

  puts "allcity_snap_count: #{allcity_snap_eligible.count}"
  puts "allcity_medicaid_count: #{ allcity_medicaid_eligible.count}"
  puts "allcity_allkids_count: #{allcity_allkids_eligible.count}"





end
