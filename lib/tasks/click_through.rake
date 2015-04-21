task :click_through => :environment do

  snap_correct_dates = []
  SnapEligibilityData.all.each do |snap_data|
    if snap_data.created_at >= "February 2, 2015" && snap_data.created_at <= "April 19, 2015"
      snap_correct_dates.push(snap_data)
    end
  end

  snap_eligible = []
  total_snap_count = snap_correct_dates.count
  snap_correct_dates.each do |snap_data|
    if snap_data.snap_eligibility_status == "yes"
      snap_eligible.push(snap_data)
    end
  end
  puts "snap_eligbile_count: #{snap_eligible.count}"
  puts "snap_percentage_eligible: #{snap_eligible.count/total_snap_count.to_f}"



  medicaid_correct_dates = []
  MedicaidData.all.each do |medicaid_data|
    if medicaid_data.created_at >= "February 2, 2015" && medicaid_data.created_at <= "April 19, 2015"
      medicaid_correct_dates.push(medicaid_data)
    end
  end

  medicaid_eligible = []
  total_medicaid_count = medicaid_correct_dates.count
  medicaid_correct_dates.each do |medicaid_data|
    if medicaid_data.medicaid_eligibility_status == "yes"
      medicaid_eligible.push(medicaid_data)
    end
  end
  puts "medicaid_eligible_count: #{medicaid_eligible.count}"
  puts "medicaid_percentage_eligible: #{medicaid_eligible.count/total_medicaid_count.to_f}"




  allkids_correct_dates = []
  AllKidsData.all.each do |allkids_data|
    if allkids_data.created_at >= "February 2, 2015" && allkids_data.created_at <= "April 19, 2015"
      allkids_correct_dates.push(allkids_data)
    end
  end

  allkids_eligible = []
  allkids_correct_dates.each do |allkids_data|
    if allkids_data.allkids_eligibility_status == "yes"
      allkids_eligible.push(allkids_data)
    end
  end
  puts "allkids_eligible_count: #{allkids_eligible.count}"



  allcity_correct_dates = []
  AllCityProgramDatum.all.each do |allcity_data|
    if allcity_data.created_at >= "February 2, 2015" && allcity_data.created_at <= "April 19, 2015"
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

  puts "allcity_snap_eligible_count: #{allcity_snap_eligible.count}"
  puts "allcity_medicaid_eligible_count: #{ allcity_medicaid_eligible.count}"
  puts "allcity_allkids_eligible_count: #{allcity_allkids_eligible.count}"


  rta_correct_dates = []
  RtaFreeRideData.all.each do |rta_data|
    if rta_data.created_at >= "February 2, 2015" && rta_data.created_at <= "April 19, 2015"
      rta_correct_dates.push(rta_data)
    end
  end

  rta_eligible = []
  total_rta_count = rta_correct_dates.count
  rta_correct_dates.each do |rta_data|
    if rta_data.rta_eligibility_status == "yes"
      rta_eligible.push(rta_data)
    end
  end
  puts "rta_eligbile_count: #{rta_eligible.count}"
  puts "rta_percentage_eligible: #{rta_eligible.count/total_rta_count.to_f}"


  rental_correct_dates = []
  RentalAssistanceData.all.each do |rental_data|
    if rental_data.created_at >= "February 2, 2015" && rental_data.created_at <= "April 19, 2015"
      rental_correct_dates.push(rental_data)
    end
  end

  rental_eligible = []
  total_rental_count = rental_correct_dates.count
  rental_correct_dates.each do |rental_data|
    if rental_data.rental_eligibility_status == "yes"
      rental_eligible.push(rental_data)
    end
  end
  puts "rental_eligbile_count: #{rental_eligible.count}"
  puts "rental_percentage_eligible: #{rental_eligible.count/total_rental_count.to_f}"





end
