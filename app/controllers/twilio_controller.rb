class TwilioController < ApplicationController

  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  def text

  session["counter"] ||= 0
  if params[:Body] == "reset" || params[:Body] == "Reset"
    session["counter"] = 0
  end

   if session["counter"] == 0
    message = "Welcome to mRelief! We help you check your eligibility for benefits. For foodstamps, type 'food'. For RTA ride free, type 'ride.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body] == "menu" || params[:Body] == "Menu"
      message = "For foodstamps, type 'food'. For RTA ride free, type 'ride.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body] == "Food" || params[:Body] == "food"
      message = "Are you enrolled in a college or institution of higher education? Enter 'yes' or 'no'"
      session["page"] = "snap_college_question"
      session["counter"] = 1
   end

   #here is the food stamps logic

   if session["page"] == "snap_college_question" && session["counter"] == 2
      session["college"] = params[:Body]
     if session["college"] == "No" || session["college"] == "NO"
       message = "Are you a citizen of the United States? Enter 'yes' or 'no'"
       session["page"] = "snap_citizen_question"
     elsif session["college"] == "Yes" || session["college"] == "YES" || session["college"] == "yes"
       session["page"] = "snap_ineligble"
     end
   end

   if session["page"] == "snap_citizen_question" && session["counter"] == 3
      session["citizen"] = params[:Body]
    if session["citizen"]  == "no" || session["citizen"]  == "No" || session["citizen"]  == "NO"
       session["page"] = "snap_eligble_maybe"
     elsif session["citizen"]  == "yes" || session["citizen"]  == "Yes" || session["citizen"]  == "YES"
       message = "How old are you? Enter a number"
       session["page"] = "snap_age_question"
     end
   end

   if session["page"] == "snap_age_question" && session["counter"] == 4
     session["age"] = params[:Body]

      if session["age"]  !~ /\D/
        session["age"] = session["age"] .to_i
      else
        session["age"] = session["age"] .in_numbers
      end

     message = "What is the number of people living in your household including yourself? Enter a number"
     session["page"] = "snap_household_question"
   end

   if session["page"] == "snap_household_question" && session["counter"] == 5
     session["dependents"] = params[:Body]

     if session["dependents"] !~ /\D/  # returns true if all numbers
       session["dependents"] = session["dependents"].to_i
     else
       session["dependents"] = session["dependents"].in_numbers
     end

     message = "What is your zipcode?"
     session["page"] = "snap_zipcode_question"
   end

   if session["page"] == "snap_zipcode_question" && session["counter"] == 6
     session["zipcode"] = params[:Body]
     message = "What is your gross monthly income? Income includes social security, child support, and unemployment insurance before any deductions."
     session["page"] = "snap_income_question"
   end

   if session["page"] == "snap_income_question" && session["counter"] == 7
     session["income"] = params[:Body]

     if session["income"] !~ /\D/
       session["income"] = session["income"].to_i
     else
       if session["income"].include?("dollars")
         session["income"].slice!"dollars"
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

      if snap_gross_income < snap_eligibility.snap_gross_income
        message = "You may be in luck! You likely qualify for foodstamps. To find a Community Service Center near you go to http://abe.illinois.gov or call 311."
      else
        message = "Based on your household size and income, you likely do not qualify for food stamps. Go to Direct2Food at http://www.direct2food.org to locate the food pantries, soup kitchens and meal programs near you. To check other programs, type 'menu'."
      end
   end

   if session["page"] == "snap_ineligble" && session["counter"] == 2
     message = "Based on your household size and income, you likely do not qualify for food stamps. Go to Direct2Food at http://www.direct2food.org to locate the food pantries, soup kitchens and meal programs near you. To check other programs, type 'menu'."
   end

   if session["page"] == "snap_eligble_maybe" && session["counter"] == 3

     user_zipcode = session["zipcode"]
     @zipcode = user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
       @laf_disclaimer = "We do not have an estimation of the nearest center that is in range for you at this time. But we recommend going to the center below."
     end

     message = "We cannot determine your eligibility at this time. To discuss your situation with a Food Stamp expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}. To check other programs, type 'menu'."
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
