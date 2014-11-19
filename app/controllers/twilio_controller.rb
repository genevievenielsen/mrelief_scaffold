class TwilioController < ApplicationController

  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  def text

  session["counter"] ||= 0

  if params[:Body].strip.downcase == "reset"
    session["counter"] = 0
  end

   if session["counter"] == 0
    message = "Welcome to mRelief! We help you check your eligibility for benefits. For foodstamps, type 'food'. For RTA ride free, type 'ride.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body].strip.downcase == "menu"
      message = "For foodstamps, type 'food'. For RTA ride free, type 'ride.' If you make a mistake, send the message 'reset'."
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

   # HERE IS THE FOOD STAMPS LOGIC

   if session["page"] == "snap_college_question" && session["counter"] == 2
      session["college"] = params[:Body].strip.downcase
     if session["college"] == "no"
       message = "Are you a citizen of the United States? Enter 'yes' or 'no'"
       session["page"] = "snap_citizen_question"
     elsif session["college"] == "yes"
       session["page"] = "snap_ineligble"
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
        session["age"] = session["age"] .to_i
      else
        session["age"] = session["age"] .in_numbers
      end

     message = "What is the number of people living in your household including yourself? Enter a number"
     session["page"] = "snap_household_question"
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
     message = "What is your gross monthly income? Income includes social security, child support, and unemployment insurance before any deductions."
     session["page"] = "snap_income_question"
   end

   if session["page"] == "snap_income_question" && session["counter"] == 7
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

      if snap_gross_income < snap_eligibility.snap_gross_income
        message = "You may be in luck! You likely qualify for foodstamps. To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}.  To check other programs, type 'menu'."
      else
        message = "Based on your household size and income, you likely do not qualify for food stamps. Go to Direct2Food at http://www.direct2food.org to locate the food pantries, soup kitchens and meal programs near you. To check other programs, type 'menu'."
      end
   end

   # Food stamps user is in school

   if session["page"] == "snap_ineligble" && session["counter"] == 2
     message = "You likely do not qualify for food stamps. Go to Direct2Food at http://www.direct2food.org to locate the food pantries, soup kitchens and meal programs near you. To check other programs, type 'menu'."
   end

   # Food stamps user is not a US citizen

   if session["page"] == "snap_eligible_maybe" && session["counter"] == 4
    session["zipcode"] = params[:Body].strip
    puts "I made it here"
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
     if session["age"] == "no"
       session["page"] = "rta_ineligble"
     elsif session["age"] == "Yes" || session["age"] == "YES" || session["age"] == "yes"
       message = "How many dependents including yourself are in your household? Enter a number"
       session["page"] = "rta_dependents_question"
     end
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

   if session["page"] == "rta_income_question" && session["counter"] == 4
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



      if rta_gross_income < rta_eligibility.rta_gross_income
        message = "You may be in luck! You likely qualify for RTA Ride Free. Click here to apply online https://idoaweb.aging.illinois.gov/baa/Welcome.aspx.c To check other programs, type 'menu'."
      else
        message = "Based on your household size and income, you likely do not qualify for RTA Ride Free. Call 312-913-3110 for information about the Reduced Fare Program. To check other programs, type 'menu'."
      end
   end

   # RTA Ride Free user is below 65

   if session["page"] == "rta_ineligble" && session["counter"] == 2
    message = "Based on your age, you do not qualify for RTA Ride Free. Call 312-913-3110 for information about the Reduced Fare Program. To check other programs, type 'menu'."
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
