require 'twilio-ruby'
class TwilioController < ApplicationController

  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  def text

  session["counter"] ||= 0

  if params[:Body].include?('"')
    params[:Body] = params[:Body].tr('"', '')
  end
  if params[:Body].include?("'")
    params[:Body] = params[:Body].tr("'", "")
  end
  #check here to see if a signature is included
  if params[:Body].strip.match(" ")
    params[:Body] = params[:Body].split(/ /).first
  end

  if params[:Body].strip.downcase == "reset"
    session["counter"] = 0
  end
  if params[:Body].strip.downcase == "hello" || params[:Body].strip.downcase == "hi" || params[:Body].strip.downcase == "hola"
    session["counter"] = 0
  end
   if session["counter"] == 0
    message = "Welcome to mRelief! We help you check your eligibility for benefits. For foodstamps, text 'food'. For RTA ride free, text 'ride.' For Medicaid, text 'medicaid.' For Medicare Cost Sharing, text 'medicare.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body].strip.downcase == "menu"
      message = "For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.' If you make a mistake, send the message 'reset'."
      session["counter"] = 0
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
      message = "At the current moment, this form does not include Medicaid's offerings for people with disabilities. If you would like to continue, answer the following question. Are you a citizen of the United States or a legal permanent resident who has lived in the US for at least 5 years? Enter 'yes' or 'no'."
      session["page"] = "medicaid_citizen_question"
      session["counter"] = 1
   end
   if params[:Body].strip.downcase == "medicare"
      message = "What is your household size? Please include yourself, your spouse, your children under 18 who live with you."
      session["page"] = "medicare_household_question"
      session["counter"] = 1
   end
   if params[:Body].strip.downcase == "med"
      message = "For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'"
      session["counter"] = 1
   end
   if params[:Body].strip.downcase.include?("food") && params[:Body].strip.downcase.include?("medicaid")
      message = "You can only check your eligibility for one form at a time. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'  "
      session["counter"] = 1
   end
   if params[:Body].strip.downcase.include?("food") && params[:Body].strip.downcase.include?("ride")
      message = "You can only check your eligibility for one form at a time. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'  "
      session["counter"] = 1
   end
   if params[:Body].strip.downcase.include?("food") && params[:Body].strip.downcase.include?("medicaid") && params[:Body].strip.downcase.include?("ride")
      message = "You can only check your eligibility for one form at a time. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'  "
      session["counter"] = 1
   end
   if params[:Body].strip.downcase.include?("food") && params[:Body].strip.downcase.include?("medicaid") && params[:Body].strip.downcase.include?("ride") && params[:Body].strip.downcase.include?("medicare")
      message = "You can only check your eligibility for one form at a time. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'  "
      session["counter"] = 1
   end

   # HERE IS THE FOOD STAMPS LOGIC
   if session["page"] == "snap_college_question" && session["counter"] == 2
      @s = SnapEligibilityDataTwilio.new
      @s.phone_number = params[:From]
      session["college"] = params[:Body].strip.downcase
     if session["college"] == "no"
       @s.enrolled_in_education = "no"
       message = "Are you a citizen of the United States or a legal permanent resident who has lived in the US for at least five years? Enter 'yes' or 'no'."
       session["page"] = "snap_citizen_question"
     elsif session["college"] == "yes"
       @s.enrolled_in_education = "yes"
       message = "What is your zipcode?"
       session["page"] = "snap_zipcode_question"
      else
        message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
        session["counter"] = 1
     end
     @s.completed = false
     @s.save
   end

   if session["page"] == "snap_citizen_question" && session["counter"] == 3
      session["citizen"] = params[:Body].strip.downcase
      @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
    if session["citizen"]  == "no"
       @s.citizen = "no"
       message = "What is your zipcode?"
       session["page"] = "snap_eligible_maybe"
     elsif session["citizen"]  == "yes"
       @s.citizen = "yes"
       message = "How old are you? Enter a number"
       session["page"] = "snap_age_question"
     else
      message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
       session["counter"] = 2
     end
     @s.completed = false
     @s.save
   end

   if session["page"] == "snap_age_question" && session["counter"] == 4
     session["age"] = params[:Body].strip
     @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      if session["age"]  !~ /\D/
        session["age"] = session["age"].to_i
      else
        session["age"]= session["age"].in_numbers
      end
     @s.age = session["age"]
     if session["age"] >= 18
      message = "What is the number of people living in your household including yourself? Enter a number"
      session["page"] = "snap_household_question"
     else
      message = "What is your zipcode?"
      session["page"] = "snap_ineligible"
    end
    @s.completed = false
    @s.save
   end

   if session["page"] == "snap_household_question" && session["counter"] == 5
     session["dependents"] = params[:Body].strip
     @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     if session["dependents"] !~ /\D/  # returns true if all numbers
       session["dependents"] = session["dependents"].to_i
     else
       session["dependents"] = session["dependents"].in_numbers
     end
     @s.dependent_no = session["dependents"]
     message = "What is your zipcode?"
     session["page"] = "snap_zipcode_question"
     @s.completed = false
     @s.save
   end

   if session["page"] == "snap_zipcode_question" && session["counter"] == 6
     session["zipcode"] = params[:Body].strip
     @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     @s.zipcode = session["zipcode"]
     message = "Are you disabled? Enter 'yes' or 'no'"
     session["page"] = "snap_disability_question"
     @s.completed = false
     @s.save
   end

   if session["page"] == "snap_disability_question" && session["counter"] == 7
      session["disability"] = params[:Body].strip.downcase
      @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     if session["disability"]  == "no"
       @s.disabled = "no"
       message = "What is the gross monthly income of all people living in your household including yourself? Income includes social security, child support, and unemployment insurance before any deductions. Enter a number. Example - 1000."
       session["page"] = "snap_income_question"
     elsif session["disability"]  == "yes"
       @s.disabled = "yes"
       message = "Are you receiving disability payments from from Social Security, the Railroad Retirement Board or Veterans Affairs? Enter 'yes' or 'no'"
       session["page"] = "snap_disability_payment"
      else
        message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
        session["counter"] = 6
      end
     @s.completed = false
     @s.save
   end

   if session["page"] == "snap_disability_payment" && session["counter"] == 8
     session["disability_payment"] = params[:Body].strip.downcase
     @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "What is the gross monthly income of all people living in your household including yourself? Income includes social security, child support, and unemployment insurance before any deductions. Enter a number. Example - 1000."
     if session["disability_payment"] == "yes"
      @s.disabled_receiving_payment = "yes"
      @disability
     elsif session["disability_payment"] == "no"
      @s.disabled_receiving_payment = "no"
     else
      message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
      session["counter"] = 7
     end
     session["page"] = "snap_income_question_disability"
     @s.completed = false
     @s.save
   end

   if session["page"] == "snap_income_question" && session["counter"] == 8
     session["income"] = params[:Body].strip
     @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
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
     @s.monthly_gross_income = session["income"]
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
        if age <= 22
          message = "You may be in luck! You likely qualify for foodstamps. However make sure you accounted for your parents income, if you are still living in the same household.  To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}.  \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        else
          message = "You may be in luck! You likely qualify for foodstamps. To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}.  \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        end
        @s.snap_eligibility_status = "yes"
      else
        message = "Based on your household size and income, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        @s.snap_eligibility_status = "no"
      end
      @s.save
      session["page"] = "snap_feedback_1"
   end

   if session["page"] == "snap_income_question_disability" && session["counter"] == 9
     session["income"] = params[:Body].strip
     @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
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
     @s.monthly_gross_income = session["income"]
     snap_dependent_no = session["dependents"].to_i
     snap_gross_income = session["income"].to_i
     age = session["age"].to_i
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
        if age <= 22
          message = "You may be in luck! You likely qualify for foodstamps. However make sure you accounted for your parents income, if you are still living in the same household.  To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}.  \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        else
          message = "You may be in luck! You likely qualify for foodstamps. To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}.  \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        end
        @s.snap_eligibility_status = "yes"
      else
        message = "Based on your household size and income, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        @s.snap_eligibility_status = "no"
      end
      @s.save
      session["page"] = "snap_feedback_2"
   end

   # Food stamps user is in school
   if session["page"] == "snap_zipcode_question" && session["counter"] == 3
    session["zipcode"] = params[:Body].strip
    @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     user_zipcode = session["zipcode"]
     @s.zipcode = user_zipcode
     @zipcode = user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
     end
     message = "We cannot determine your eligibility at this time. To discuss your situation with a Food Stamp expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @s.snap_eligibility_status = "maybe"
     @s.save
     session["page"] = "snap_feedback_3"
   end

   # Food stamps user is not a US citizen
   if session["page"] == "snap_eligible_maybe" && session["counter"] == 4
    session["zipcode"] = params[:Body].strip
    @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     user_zipcode = session["zipcode"]
     @zipcode = user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
     end
     message = "We cannot determine your eligibility at this time. To discuss your situation with a Food Stamp expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @s.snap_eligibility_status = "maybe"
     @s.save
     session["page"] = "snap_feedback_4"
   end

    # Food stamps user is younger than 18
   if session["page"] == "snap_ineligible" && session["counter"] == 5
    @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
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
    message = "Based on your age, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
    @s.snap_eligibility_status = "no"
    @s.save
    session["page"] = "snap_feedback_5"
   end

   # HERE IS THE FEEDBACK LOGIC FOR FOODSTAMPS
   if session["page"] == "snap_feedback_1" && session["counter"] == 9
      @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      message = "Thank you so much for your feedback! To check other programs, text 'menu'."
      @s.feedback = params[:Body]
      @s.completed = true
      @s.save

   elsif session["page"] == "snap_feedback_2" && session["counter"] == 10
      @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      message = "Thank you so much for your feedback! To check other programs, text 'menu'."
      @s.feedback = params[:Body]
      @s.completed = true
      @s.save

   elsif session["page"] == "snap_feedback_3" && session["counter"] == 4
      @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      message = "Thank you so much for your feedback! To check other programs, text 'menu'."
      @s.feedback = params[:Body]
      @s.completed = true
      @s.save

   elsif session["page"] == "snap_feedback_4" && session["counter"] == 5
      @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      message = "Thank you so much for your feedback! To check other programs, text 'menu'."
      @s.feedback = params[:Body]
      @s.completed = true
      @s.save

   elsif session["page"] == "snap_feedback_5" && session["counter"] == 6
      @s = SnapEligibilityDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      message = "Thank you so much for your feedback! To check other programs, text 'menu'."
      @s.feedback = params[:Body]
      @s.completed = true
      @s.save
   end


   # HERE IS THE LOGIC FOR RTA RIDE FREE
   if session["page"] == "rta_age_question" && session["counter"] == 2
      @r = RtaFreeRideDataTwilio.new
      @r.phone_number = params[:From]
      session["age"] = params[:Body].strip.downcase
      if session["age"]  == "no"
        @r.over_sixty_five = "no"
        message = "Are you disabled? Enter 'yes' or 'no'"
        session["page"] = "rta_disability_question"
      elsif session["age"]  == "yes"
         @r.over_sixty_five = "yes"
         message = "How many dependents including yourself are in your household? Enter a number"
         session["page"] = "rta_dependents_question"
      else
        message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
        session["counter"] = 1
      end
      @r.completed = false
      @r.save
   end

   if session["page"] == "rta_disability_question" && session["counter"] == 3
    session["disabled"] = params[:Body].strip.downcase
    @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
    if session["disabled"] == "no"
      @r.disabled = "no"
      session["page"] = "rta_ineligble"
      message = "What is your zipcode?"
    elsif session["disabled"] == "yes"
      @r.disabled = "yes"
      message = "Are you receiving disability payments from from Social Security, the Railroad Retirement Board or Veterans Affairs? Enter 'yes' or 'no'"
      session["page"] = "rta_disability_payment"
    else
      message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
      session["counter"] = 2
    end
    @r.save
   end

   if session["page"] == "rta_disability_payment" && session["counter"] == 4
     session["disability_payment"] = params[:Body].strip.downcase
     @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     if session["disability_payment"] == "yes"
      @r.disabled_receiving_payments = "yes"
      message = "How many dependents including yourself are in your household? Enter a number"
      session["page"] = "rta_dependents_question"
     elsif session["disability_payment"] == "no"
      @r.disabled_receiving_payments = "no"
      session["page"] = "rta_ineligble"
      message = "What is your zipcode?"
      else
        message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
        session["counter"] = 3
     end
     @r.save
   end

    if session["page"] == "rta_dependents_question" && session["counter"] == 5
      session["dependents"] = params[:Body].strip
      @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      if session["dependents"] !~ /\D/  # returns true if all numbers
        session["dependents"] = session["dependents"].to_i
      else
        session["dependents"] = session["dependents"].in_numbers
      end
      @r.dependent_no = session["dependents"]
      message = "What is your gross annual income? Income includes your spouse's income if married and living together on December 31 of last year before tax deductions. Enter a number. Example - 10000."
      session["page"] = "rta_income_question"
      @r.save
    end

    if session["page"] == "rta_dependents_question" && session["counter"] == 3
      session["dependents"] = params[:Body].strip
      @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      if session["dependents"] !~ /\D/  # returns true if all numbers
        session["dependents"] = session["dependents"].to_i
      else
        session["dependents"] = session["dependents"].in_numbers
      end
      @r.dependent_no = session["dependents"]
      message = "What is your gross annual income? Income includes your spouse's income if married and living together on December 31 of last year before tax deductions. Enter a number.  Example - 10000."
      session["page"] = "rta_income_question"
      @r.save
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
     @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     @r.dependent_no = session["dependents"].to_i
     @r.gross_annual_income = session["income"].to_i
     @r.save
     if session["counter"] == 4
       if rta_gross_income < rta_eligibility.rta_gross_income
         message = "You may be in luck! You likely qualify for RTA Ride Free. Call 1-800-252-8966(toll free) for help with your application.  \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
         @r.rta_eligibility_status = "yes"
         session["page"] = "rta_feedback_1"
       else
         session["page"] = "rta_ineligble"
         message = "What is your zipcode?"
       end
       @r.save
      end
    end

    if session["page"] == "rta_income_question" && session["counter"] == 6
      @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      if rta_gross_income < rta_eligibility.rta_gross_income
        message = "You may be in luck! You likely qualify for RTA Ride Free. Call 1-800-252-8966(toll free) for help with your application.  \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        @r.rta_eligibility_status = "yes"
        session["page"] = "rta_feedback_2"
      else
        session["page"] = "rta_ineligble"
        message = "What is your zipcode?"
      end
      @r.save
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
      @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
      @r.zipcode = session["zipcode"]
      message = "You likely do not qualify for RTA Ride Free. A transportation resource near you is #{@transportation_center.name} - #{@transportation_center.street} #{@transportation_center.city} #{@transportation_center.state}, #{@transportation_center.zip} #{@transportation_center.phone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
      @r.rta_eligibility_status = "no"
      session["page"] = "rta_feedback_ineligible"
     end
   end

   # RTA FEEDBACK QUESTIONS
  if session["page"] == "rta_feedback_1" && session["counter"] == 5
    @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @r.feedback = params[:Body]
     @r.completed = true
     @r.save

  elsif session["page"] == "rta_feedback_2" && session["counter"] == 7
    @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @r.feedback = params[:Body]
     @r.completed = true
     @r.save

  elsif session["page"] == "rta_feedback_ineligible"
   if session["counter"] == 5 || session["counter"] == 6 || session["counter"] == 7 || session["counter"] == 8
     @r = RtaFreeRideDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @r.feedback = params[:Body]
     @r.completed = true
     @r.save
   end
  end


   # HERE IS THE LOGIC FOR MEDICAID
   if session["page"] == "medicaid_citizen_question" && session["counter"] == 2
     @m = MedicaidDataTwilio.new
     @m.phone_number = params[:From]
     session["citizen"] = params[:Body].strip.downcase
    if session["citizen"]  == "no"
       @m.citizen = "no"
       message = "What is your zipcode?"
       session["page"] = "medicaid_eligible_maybe"
     elsif session["citizen"]  == "yes"
       @m.citizen = "yes"
       message = "How many people live in your home (including yourself)?"
       session["page"] = "medicaid_household_size"
     else
      message = "Oops looks like there is a typo! Please type 'yes' or 'no' to answer this question."
      session["counter"] = 1
     end
     @m.completed = "false"
     @m.save
   end

   if session["page"] == "medicaid_household_size" && session["counter"] == 3
     session["household"] = params[:Body].strip
     @m = MedicaidDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
     if session["household"] !~ /\D/  # returns true if all numbers
       session["household"] = session["household"].to_i
     else
       session["household"] = session["household"].in_numbers
     end
     @m.household_size = session["household"]
     message = "What is your monthly income? Enter a number. Enter a number. Example - 1000."
     session["page"] = "medicaid_income_question"
     @m.save
   end

   if session["page"] == "medicaid_income_question" && session["counter"] == 4
     session["income"] = params[:Body].strip
     @m = MedicaidDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
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
     @m.monthly_gross_income = session["income"]
     medicaid_household_size = session["household"].to_i
     medicaid_gross_income = session["income"].to_i
     medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => medicaid_household_size})
      if medicaid_gross_income < medicaid_eligibility.medicaid_gross_income
        message = "You may be in luck! You likely qualify for Medicaid. Call (866) 311-1119 for your coverage options. To further pursue your Medicaid application you can also call the county care line (312-864-8200). If you already have a doctor, be sure to confirm they transfer over. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        @m.medicaid_eligibility_status = "yes"
        session["page"] = "medicaid_feedback_1"
      else
        message = "What is your zipcode?"
        session["page"] = "medicaid_ineligible"
      end
      @m.save
   end

   # Medicaid user is ineligible
   if session["page"] == "medicaid_ineligible" && session["counter"] == 5
     @m = MedicaidDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
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
      message = "You likely do not qualify for Medicaid. A medical clinic near you is #{@medical_center.name} - #{@medical_center.street} #{@medical_center.city} #{@medical_center.state}, #{@medical_center.zip} #{@medical_center.phone}. If your family doesn't have health coverage, you may have to pay a fee and all health costs. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
      @m.medicaid_eligibility_status = "no"
      @m.zipcode = zipcode
      session["page"] = "medicaid_feedback_2"
      @m.save
    end

   # Medicaid user is not a US citizen
   if session["page"] == "medicaid_eligible_maybe" && session["counter"] == 3
    @m = MedicaidDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
    session["zipcode"] = params[:Body].strip
    user_zipcode = session["zipcode"]
    @zipcode = user_zipcode << ".0"
    @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
    if @lafcenter.present?
    else
      @lafcenter = LafCenter.find_by(:id => 10)
    end
     message = "We cannot determine your eligibility at this time. To discuss your situation with a Medicaid expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @m.medicaid_eligibility_status = "maybe"
     @m.zipcode = user_zipcode
     session["page"] = "medicaid_feedback_3"
     @m.save
   end

   # MEDICAID FEEDBACK QUESTIONS
   if session["page"] == "medicaid_feedback_1" && session["counter"] == 5
    @m = MedicaidDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
    message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
    @m.feedback = params[:Body]
    @m.completed = "true"
    @m.save
   elsif session["page"] == "medicaid_feedback_2" && session["counter"] == 6
    @m = MedicaidDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
    message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
    @m.feedback = params[:Body]
    @m.completed = "true"
    @m.save
   elsif session["page"] == "medicaid_feedback_3" && session["counter"] == 4
     @m = MedicaidDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @m.feedback = params[:Body]
     @m.completed = "true"
     @m.save
   end

   # HERE IS THE MEDICARE COST SHARING LOGIC
   if session["page"] == "medicare_household_question" && session["counter"] == 2
    @mc = MedicareCostSharingDataTwilio.new
    @mc.phone_number = params[:From]
    session["household"] = params[:Body].strip
    if session["household"] !~ /\D/  # returns true if all numbers
      session["household"] = session["household"].to_i
    else
      session["household"] = session["household"].in_numbers
    end
    @mc.household_size = session["household"]
    message = "How many people in your household receive Medicare? Please enter a number"
    session["page"] = "medicare_number_question"
    @mc.completed = "false"
    @mc.save
   end

   if session["page"] == "medicare_number_question" && session["counter"] == 3
    session["medicare_number"] = params[:Body].strip
    @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
    if session["medicare_number"] !~ /\D/  # returns true if all numbers
      session["medicare_number"] = session["medicare_number"].to_i
    else
      session["medicare_number"] = session["medicare_number"].in_numbers
    end
    @mc.medicare_household_size = session["medicare_number"]
    if session["medicare_number"] == 0
      message = "What is your zipcode?"
      session["page"] = "medicare_ineligible"
    else
      message = "What is your gross monthly income? Enter a number. Example - 1000."
      session["page"] = "medicare_income_question"
    end
    @mc.save
   end

   if session["page"] == "medicare_income_question" && session["counter"] == 4
     @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
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
     @mc.monthly_gross_income = session["income"]
     message = "Please estimate the value of your assets.  This includes such items as: money in checking and savings accounts; stocks, bonds, savings certificates, and other securities; farm and small business equipment, unless used for income for self-support, estate bequests; and miscellaneous resources that are not real property. Please exclude the value of your home and car. Enter a number. Example - 10000."
     session["page"] = "medicare_assests_question"
     @mc.save
   end

   if session["page"] == "medicare_assests_question" && session["counter"] == 5
     @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
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
     @mc.assets = session["assets"]
     assets = session["assets"]
     household_size = session["household"]
     medicare_household_size = session["medicare_number"]
     monthly_income = session["income"]
     if medicare_household_size == 0
      @eligible = "no"
     elsif household_size == 1 && assets > 7280
      @eligible = "no"
     elsif household_size > 1 && assets > 10930
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
     @mc.save
   end

   if session["page"] == "medicare_eligible" && session["counter"] == 6
    @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
    session["zipcode"] = params[:Body].strip
     user_zipcode = session["zipcode"]
     @zipcode = user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
     end
    message = "You may be in luck! You likely qualify for Medicare Cost Sharing. To access your Medicare Care Sharing, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
    @mc.zipcode = user_zipcode
    @mc.medicare_cost_sharing_eligibility_status = "yes"
    session["page"] = "mcs_feedback_1"
    @mc.save
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
       @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
       #NO one in the household is on medicare
        message = "You likely do not qualify for Medicare Cost Sharing. A medical clinic near you is #{@medical_center.name} - #{@medical_center.street} #{@medical_center.city} #{@medical_center.state}, #{@medical_center.zip} #{@medical_center.phone}. If your family doesn't have health coverage, you may have to pay a fee and all health costs. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        @mc.zipcode = zipcode
        @mc.medicare_cost_sharing_eligibility_status = "no"
        session["page"] = "mcs_feedback_2"
        @mc.save
     elsif session["counter"] == 6
        @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => "false")
        #Medicare cost sharing user does not meet eligiblty cut offs
        message = "You likely do not qualify for Medicare Cost Sharing. A medical clinic near you is #{@medical_center.name} - #{@medical_center.street} #{@medical_center.city} #{@medical_center.state}, #{@medical_center.zip} #{@medical_center.phone}. If your family doesn't have health coverage, you may have to pay a fee and all health costs. \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
        @mc.zipcode = zipcode
        @mc.medicare_cost_sharing_eligibility_status = "no"
        session["page"] = "mcs_feedback_3"
        @mc.save
     end
   end

   if session["page"] == "mcs_feedback_1" && session["counter"] == 7
     @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @mc.feedback = params[:Body]
     @mc.completed = "true"
     @mc.save
   elsif session["page"] == "mcs_feedback_2" && session["counter"] == 5
     @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @mc.feedback = params[:Body]
     @mc.completed = "true"
     @mc.save
   elsif session["page"] == "mcs_feedback_3" && session["counter"] == 7
     @mc = MedicareCostSharingDataTwilio.find_or_create_by(:phone_number => params[:From].strip, :completed => false)
     message = "Thank you so much for your feedback! \n How satisfied are you with your mRelief experience on a scale of 5 (very satisfied) to 1 (very dissatisfied)?"
     @mc.feedback = params[:Body]
     @mc.completed = "true"
     @mc.save
   end

   twiml = Twilio::TwiML::Response.new do |r|
       r.Message message
   end
    session["counter"] += 1

    respond_to do |format|
     format.xml {render xml: twiml.text}
   end
  end


  include Webhookable

   after_filter :set_header

   skip_before_action :verify_authenticity_token

   def voice

     response = Twilio::TwiML::Response.new do |r|
        r.Play 'https://dl.dropboxusercontent.com/s/vaq6et51o8ohwxz/mRelief.mp3'
     end

     render_twiml response
   end

end
