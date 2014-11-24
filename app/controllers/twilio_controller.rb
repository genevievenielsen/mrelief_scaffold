class TwilioController < ApplicationController


 # if they don't qualify under normal and are disabled but not receiving payments

# add laf centers to rta
# NO zipcode for rta ride free
# NO purple binder


  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  def text

  session["counter"] ||= 0

  if params[:Body].strip.downcase == "reset"
    session["counter"] = 0
  end

   if session["counter"] == 0
    message = "Welcome to mRelief! We help you check your eligibility for benefits. For foodstamps, type 'food'. For RTA ride free, type 'ride.' For Medicaid, type 'medicaid.' For Medicare Cost Sharing, type 'medicare.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body].strip.downcase == "menu"
      message = "For foodstamps, type 'food'. For RTA ride free, type 'ride.' For Medicaid, type 'medicaid.' For Medicare Cost Sharing, type 'medicare.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body].strip.downcase == "food"
      message = "Are you enrolled in a college or institution of higher education? Enter 'yes' or 'no'"
      session["page"] = "snap_college_question"
      session["counter"] = 1
   end

   if params[:Body].strip.downcase == "ride"
      message = "Are you 65 years old or older? Enter 'yes' or 'no'"
      session["page"] = "rta_age_question"
      session["counter"] = 1
   end

   if params[:Body].strip.downcase == "medicaid"
      message = "Are you a citizen of the United States? Enter 'yes' or 'no'"
      session["page"] = "medicaid_citizen_question"
      session["counter"] = 1
   end

   if params[:Body].strip.downcase == "medicare"
      message = "What is your household size? Please include yourself, your spouse, your children under 18 who live with you."
      session["page"] = "medicare_household_question"
      session["counter"] = 1
   end

   # HERE IS THE FOOD STAMPS LOGIC
   if session["page"] == "snap_college_question" && session["counter"] == 2
      session["college"] = params[:Body].strip.downcase
     if session["college"] == "no"
       message = "Are you a citizen of the United States? Enter 'yes' or 'no'"
       session["page"] = "snap_citizen_question"
     elsif session["college"] == "yes"
       message = "What is your zipcode?"
       session["page"] = "snap_zipcode_question"
     end
   end

   if session["page"] == "snap_citizen_question" && session["counter"] == 3
      session["citizen"] = params[:Body].strip.downcase
    if session["citizen"]  == "no"
       message = "What is your zipcode?"
       session["page"] = "snap_eligible_maybe"
     elsif session["citizen"]  == "yes"
       message = "How old are you? Enter a number"
       session["page"] = "snap_age_question"
     end
   end

   if session["page"] == "snap_age_question" && session["counter"] == 4
     session["age"] = params[:Body].strip
      if session["age"]  !~ /\D/
        session["age"] = session["age"].to_i
      else
        session["age"] = session["age"].in_numbers
      end
     if session["age"] >= 22
      message = "What is the number of people living in your household including yourself? Enter a number"
      session["page"] = "snap_household_question"
     else
      message = "What is your zipcode?"
      session["page"] = "snap_ineligible"
    end
   end

   if session["page"] == "snap_household_question" && session["counter"] == 5
     session["dependents"] = params[:Body].strip
     if session["dependents"] !~ /\D/  # returns true if all numbers
       session["dependents"] = session["dependents"].to_i
     else
       session["dependents"] = session["dependents"].in_numbers
     end
     message = "What is your zipcode?"
     session["page"] = "snap_zipcode_question"
   end

   if session["page"] == "snap_zipcode_question" && session["counter"] == 6
     session["zipcode"] = params[:Body].strip
     message = "Are you disabled? Enter 'yes' or 'no'"
     session["page"] = "snap_disability_question"
   end

   if session["page"] == "snap_disability_question" && session["counter"] == 7
      session["disability"] = params[:Body].strip.downcase
     if session["disability"]  == "no"
       message = "What is the gross monthly income of all people living in your household including yourself? Income includes social security, child support, and unemployment insurance before any deductions."
       session["page"] = "snap_income_question"
     elsif session["disability"]  == "yes"
       message = "Are you receiving disability payments from from Social Security, the Railroad Retirement Board or Veterans Affairs? Enter 'yes' or 'no'"
       session["page"] = "snap_disability_payment"
     end
   end

   if session["page"] == "snap_disability_payment" && session["counter"] == 8
     session["disability_payment"] = params[:Body].strip
     message = "What is the gross monthly income of all people living in your household including yourself? Income includes social security, child support, and unemployment insurance before any deductions."
     if session["disability_payment"] == "yes"
      @disability
     end
     session["page"] = "snap_income_question_disability"
   end

   if session["page"] == "snap_income_question" && session["counter"] == 8
     session["income"] = params[:Body].strip
     if session["income"] !~ /\D/
       session["income"] = session["income"].to_i
     else
       if session["income"].include?("dollars")
         session["income"].slice!"dollars"
       end
       if session["income"].include?("$")
         session["income"].slice!"$"
       end
       if session["income"].include?(",")
         session["income"].slice!","
       end
       session["income"] = session["income"].in_numbers
     end
     age = session["age"].to_i
     snap_dependent_no = session["dependents"].to_i
     snap_gross_income = session["income"].to_i
      if age <= 59
        snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => snap_dependent_no })
      else
        snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => snap_dependent_no })
      end
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      @food_resources = ServiceCenter.where(:description => "food pantry")
      @food_resources_zip = @food_resources.where(:zip => user_zipcode)
      if @food_resources_zip.present?
        @food_pantry = @food_resources_zip.first
      else
        @food_pantry = @food_resources.first
      end
      if snap_gross_income < snap_eligibility.snap_gross_income
        message = "You may be in luck! You likely qualify for foodstamps. To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}.  To check other programs, type 'menu'."
      else
        message = "Based on your household size and income, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}. To check other programs, type 'menu'."
      end
   end
   if session["page"] == "snap_income_question_disability" && session["counter"] == 9
     session["income"] = params[:Body].strip
     if session["income"] !~ /\D/
       session["income"] = session["income"].to_i
     else
       if session["income"].include?("dollars")
         session["income"].slice!"dollars"
       end
       if session["income"].include?("$")
         session["income"].slice!"$"
       end
       if session["income"].include?(",")
         session["income"].slice!","
       end
       session["income"] = session["income"].in_numbers
     end
     snap_dependent_no = session["dependents"].to_i
     snap_gross_income = session["income"].to_i
      if @disability.present?
        snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => snap_dependent_no })
      else
        snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => snap_dependent_no })
      end
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      @food_resources = ServiceCenter.where(:description => "food pantry")
      @food_resources_zip = @food_resources.where(:zip => user_zipcode)
      if @food_resources_zip.present?
        @food_pantry = @food_resources_zip.first
      else
        @food_pantry = @food_resources.first
      end
      if snap_gross_income < snap_eligibility.snap_gross_income
        message = "You may be in luck! You likely qualify for foodstamps. To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}.  To check other programs, type 'menu'."
      else
        message = "Based on your household size and income, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}. To check other programs, type 'menu'."
      end
   end

   # Food stamps user is younger than 22
   if session["page"] == "snap_ineligible" && session["counter"] == 5
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      @food_resources = ServiceCenter.where(:description => "food pantry")
      @food_resources_zip = @food_resources.where(:zip => user_zipcode)
      if @food_resources_zip.present?
        @food_pantry = @food_resources_zip.first
      else
        @food_pantry = @food_resources.first
      end
      message = "Based on your age, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}. To check other programs, type 'menu'."
   end

   # Food stamps user is in school
   if session["page"] == "snap_zipcode_question" && session["counter"] == 3
    session["zipcode"] = params[:Body].strip
     user_zipcode = session["zipcode"]
     @zipcode = user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
     end
     message = "We cannot determine your eligibility at this time. To discuss your situation with a Food Stamp expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. To check other programs, type 'menu'."
   end

   # Food stamps user is not a US citizen
   if session["page"] == "snap_eligible_maybe" && session["counter"] == 4
    session["zipcode"] = params[:Body].strip
     user_zipcode = session["zipcode"]
     @zipcode = user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
     end
     message = "We cannot determine your eligibility at this time. To discuss your situation with a Food Stamp expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. To check other programs, type 'menu'."
   end


   # HERE IS THE LOGIC FOR RTA RIDE FREE
   if session["page"] == "rta_age_question" && session["counter"] == 2
      session["age"] = params[:Body].strip.downcase
      if session["age"]  == "no"
        message = "Are you disabled? Enter 'yes' or 'no'"
        session["page"] = "rta_disability_question"
      else
         message = "How many dependents including yourself are in your household? Enter a number"
         session["page"] = "rta_dependents_question"
      end
   end

   if session["page"] == "rta_disability_question" && session["counter"] == 3
    session["disabled"] = params[:Body].strip.downcase
    if session["disabled"] == "no"
      session["page"] = "rta_ineligble"
      message = "What is your zipcode?"
    else
      message = "Are you receiving disability payments from from Social Security, the Railroad Retirement Board or Veterans Affairs? Enter 'yes' or 'no'"
      session["page"] = "snap_disability_payment"
    end
   end

   if session["page"] == "snap_disability_payment" && session["counter"] == 4
     session["disability_payment"] = params[:Body].strip.downcase
     if session["disability_payment"] == "yes"
      message = "How many dependents including yourself are in your household? Enter a number"
      session["page"] = "rta_dependents_question"
     else
      session["page"] = "rta_ineligble"
      message = "What is your zipcode?"
     end
   end

    if session["page"] == "rta_dependents_question" && session["counter"] == 5
      session["dependents"] = params[:Body].strip
      if session["dependents"] !~ /\D/  # returns true if all numbers
        session["dependents"] = session["dependents"].to_i
      else
        session["dependents"] = session["dependents"].in_numbers
      end
      message = "What is your gross annual income? Income includes your spouse's income if married and living together on December 31 of last year before tax deductions.  Enter a number"
      session["page"] = "rta_income_question"
    end
    if session["page"] == "rta_dependents_question" && session["counter"] == 3
      session["dependents"] = params[:Body].strip
      if session["dependents"] !~ /\D/  # returns true if all numbers
        session["dependents"] = session["dependents"].to_i
      else
        session["dependents"] = session["dependents"].in_numbers
      end
      message = "What is your gross annual income? Income includes your spouse's income if married and living together on December 31 of last year before tax deductions.  Enter a number"
      session["page"] = "rta_income_question"
    end

    if session["page"] == "rta_income_question"
      session["income"] = params[:Body].strip
      if session["income"] !~ /\D/
        session["income"] = session["income"].to_i
      else
        if session["income"].include?("dollars")
          session["income"].slice!"dollars"
        end
        if session["income"].include?("$")
          session["income"].slice!"$"
        end
        if session["income"].include?(",")
          session["income"].slice!","
        end
        session["income"] = session["income"].in_numbers
      end
       rta_dependent_no = session["dependents"].to_i
       rta_gross_income = session["income"].to_i
       rta_eligibility = RtaFreeRide.find_by({ :rta_dependent_no => rta_dependent_no })
    end
    if session["page"] == "rta_income_question" && session["counter"] == 4
     if session["counter"] == 4
       if rta_gross_income < rta_eligibility.rta_gross_income
         message = "You may be in luck! You likely qualify for RTA Ride Free. Call 1-800-252-8966(toll free) for help with your application.  To check other programs, type 'menu'."
       else
         session["page"] = "rta_ineligble"
         message = "What is your zipcode?"
       end
      end
    end

    if session["page"] == "rta_income_question" && session["counter"] == 6
       if rta_gross_income < rta_eligibility.rta_gross_income
         message = "You may be in luck! You likely qualify for RTA Ride Free. Call 1-800-252-8966(toll free) for help with your application.  To check other programs, type 'menu'."
       else
         session["page"] = "rta_ineligble"
         message = "What is your zipcode?"
       end
    end

   if session["page"] == "rta_ineligble"
    session["zipcode"] = params[:Body].strip
    zipcode = session["zipcode"]
    transportation = []
     ServiceCenter.all.each do |center|
       if center.description.match("transportation")
         transportation.push(center)
       end
     end
     @transportation_resources_zip = []
     transportation.each do |center|
       if center.zip.match(zipcode)
         @transportation_resources_zip.push(center)
       end
     end
     if @transportation_resources_zip.present?
      @transportation_center = @transportation_resources_zip.first
     else
      @transportation_center = transportation.first
     end
     if session["counter"] == 4 || session["counter"] == 5 || session["counter"] == 6 || session["counter"] == 7
      message = "You likely do not qualify for RTA Ride Free. A transportation resource near you is #{@transportation_center.name} - #{@transportation_center.street} #{@transportation_center.city} #{@transportation_center.state}, #{@transportation_center.zip} #{@transportation_center.phone}. To check other programs, type 'menu'."
     end
   end


   # HERE IS THE LOGIC FOR MEDICAID
   if session["page"] == "medicaid_citizen_question" && session["counter"] == 2
     session["citizen"] = params[:Body].strip.downcase
    if session["citizen"]  == "no"
       message = "What is your zipcode?"
       session["page"] = "medicaid_eligible_maybe"
     elsif session["citizen"]  == "yes"
      message = " How many people live in your home (including yourself)?"
      session["page"] = "medicaid_household_size"
     end
   end

   if session["page"] == "medicaid_household_size" && session["counter"] == 3
     session["household"] = params[:Body].strip
     if session["household"] !~ /\D/  # returns true if all numbers
       session["household"] = session["household"].to_i
     else
       session["household"] = session["household"].in_numbers
     end
     message = "What is your monthly income? Enter a number"
     session["page"] = "medicaid_income_question"
   end

   if session["page"] == "medicaid_income_question" && session["counter"] == 4
     session["income"] = params[:Body].strip
     if session["income"] !~ /\D/
       session["income"] = session["income"].to_i
     else
       if session["income"].include?("dollars")
         session["income"].slice!"dollars"
       end
       if session["income"].include?("$")
         session["income"].slice!"$"
       end
       if session["income"].include?(",")
         session["income"].slice!","
       end
       session["income"] = session["income"].in_numbers
     end
     medicaid_household_size = session["household"].to_i
     medicaid_gross_income = session["income"].to_i
     medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => medicaid_household_size})
      if medicaid_gross_income < medicaid_eligibility.medicaid_gross_income
        message = "You may be in luck! You likely qualify for Medicaid. Call (866) 311-1119 for your coverage options. To check other programs, type 'menu'."
      else
        message = "What is your zipcode?"
        session["page"] = "medicaid_ineligible"
      end
   end

   # Medicaid user is ineligible
   if session["page"] == "medicaid_ineligible" && session["counter"] == 5
     session["zipcode"] = params[:Body].strip
     zipcode = session["zipcode"]
      primarycare = []
      ServiceCenter.all.each do |center|
        if center.description.match("primary care")
          primarycare.push(center)
        end
      end
      @medical_resources_zip = []
      primarycare.each do |center|
        if center.zip.match(zipcode)
          @medical_resources_zip.push(center)
        end
      end
      if @medical_resources_zip.present?
       @medical_center = @medical_resources_zip.first
      else
       @medical_center = primarycare.first
      end
      message = "You likely do not qualify for Medicaid. A medical clinic near you is #{@medical_center.name} - #{@medical_center.street} #{@medical_center.city} #{@medical_center.state}, #{@medical_center.zip} #{@medical_center.phone}. If your family doesn't have health coverage, you may have to pay a fee and all health costs. To check other programs, type 'menu'."
   end

   # Medicaid user is not a US citizen
   if session["page"] == "medicaid_eligible_maybe" && session["counter"] == 3
    session["zipcode"] = params[:Body].strip
    user_zipcode = session["zipcode"]
    @zipcode = user_zipcode << ".0"
    @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
    if @lafcenter.present?
    else
      @lafcenter = LafCenter.find_by(:id => 10)
    end
     message = "We cannot determine your eligibility at this time. To discuss your situation with a Medicaid expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. To check other programs, type 'menu'."
   end

   # HERE IS THE MEDICARE COST SHARING LOGIC
   if session["page"] == "medicare_household_question" && session["counter"] == 2
    session["household"] = params[:Body].strip
    if session["household"] !~ /\D/  # returns true if all numbers
      session["household"] = session["household"].to_i
    else
      session["household"] = session["household"].in_numbers
    end
    message = "How many people in your household receive Medicare?"
    session["page"] = "medicare_number_question"
   end

   if session["page"] == "medicare_number_question" && session["counter"] == 3
    session["medicare_number"] = params[:Body].strip
    if session["medicare_number"] !~ /\D/  # returns true if all numbers
      session["medicare_number"] = session["medicare_number"].to_i
    else
      session["medicare_number"] = session["medicare_number"].in_numbers
    end
    if session["medicare_number"] == 0
      message = "What is your zipcode?"
      session["page"] = "medicare_ineligible"
    else
      message = "What is you gross monthly income? Enter a number"
      session["page"] = "medicare_income_question"
    end
   end

   if session["page"] == "medicare_income_question" && session["counter"] == 4
     session["income"] = params[:Body].strip
     if session["income"] !~ /\D/
       session["income"] = session["income"].to_i
     else
       if session["income"].include?("dollars")
         session["income"].slice!"dollars"
       end
       if session["income"].include?("$")
         session["income"].slice!"$"
       end
       if session["income"].include?(",")
         session["income"].slice!","
       end
       session["income"] = session["income"].in_numbers
     end
     message = "Please estimate the value of your assets.  This includes such items as: money in checking and savings accounts; stocks, bonds, savings certificates, and other securities; farm and small business equipment, unless used for income for self-support, estate bequests; and miscellaneous resources that are not real property. Please exclude the value of your home and car. Enter a number"
     session["page"] = "medicare_assests_question"
   end

   if session["page"] == "medicare_assests_question" && session["counter"] == 5
     session["assets"] = params[:Body].strip
     if session["assets"] !~ /\D/
       session["assets"] = session["assets"].to_i
     else
       if session["assets"].include?("dollars")
         session["assets"].slice!"dollars"
       end
       if session["assets"].include?("$")
         session["assets"].slice!"$"
       end
       if session["assets"].include?(",")
         session["assets"].slice!","
       end
       session["assets"] = session["assets"].in_numbers
     end
     assets = session["assets"]
     household_size = session["household"]
     medicare_household_size = session["medicare_number"]
     monthly_income = session["income"]
     if medicare_household_size == 0
      @eligible = "no"
     elsif household_size == 1 && assets > 7160
      @eligible = "no"
     elsif household_size > 1 && assets > 10750
      @eligible = "no"
     else
      if medicare_household_size == 1
        monthly_income = monthly_income - 25
      elsif medicare_household_size == 2
        monthly_income = monthly_income - 50
      end
      medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => household_size })
      if monthly_income < medicare_sharing_eligibility.premium_only
        @eligible = "yes"
        if monthly_income < medicare_sharing_eligibility.medicare_cost_sharing
          @eligible_p_d_c = "yes"
        elsif monthly_income >= medicare_sharing_eligibility.medicare_cost_sharing
          @eligible_p = "yes"
        end
      end
      end
     if @eligible == "yes"
      message = "What is your zipcode?"
      session["page"] = "medicare_eligible"
     elsif @eligible == "no"
      message = "What is your zipcode?"
      session["page"] = "medicare_ineligible"
     end
   end

   if session["page"] == "medicare_eligible" && session["counter"] == 6
    session["zipcode"] = params[:Body].strip
     user_zipcode = session["zipcode"]
     @zipcode = user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
     end
    message = "You may be in luck! You likely qualify for Medicare Cost Sharing. To access your Medicare Care Sharing, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. To check other programs, type 'menu'."
   end

   if session["page"] == "medicare_ineligible"
    session["zipcode"] = params[:Body].strip
     zipcode = session["zipcode"]
     primarycare = []
     ServiceCenter.all.each do |center|
       if center.description.match("primary care")
         primarycare.push(center)
       end
     end
     @medical_resources_zip = []
     primarycare.each do |center|
       if center.zip.match(zipcode)
         @medical_resources_zip.push(center)
       end
     end
     if @medical_resources_zip.present?
      @medical_center = @medical_resources_zip.first
     else
      @medical_center = primarycare.first
     end
     if session["counter"] == 4
       #NO one in the household is on medicare
        message = "You likely do not qualify for Medicare Cost Sharing. A medical clinic near you is #{@medical_center.name} - #{@medical_center.street} #{@medical_center.city} #{@medical_center.state}, #{@medical_center.zip} #{@medical_center.phone}. If your family doesn't have health coverage, you may have to pay a fee and all health costs. To check other programs, type 'menu'."
     elsif session["counter"] == 6
      # Medicare cost sharing user does not meet eligiblty cut offs
        message = "You likely do not qualify for Medicare Cost Sharing. A medical clinic near you is #{@medical_center.name} - #{@medical_center.street} #{@medical_center.city} #{@medical_center.state}, #{@medical_center.zip} #{@medical_center.phone}. If your family doesn't have health coverage, you may have to pay a fee and all health costs. To check other programs, type 'menu'."
     end
   end


   twiml = Twilio::TwiML::Response.new do |r|
       r.Message message
   end
    session["counter"] += 1

    respond_to do |format|
     format.xml {render xml: twiml.text}
   end



  end

end
