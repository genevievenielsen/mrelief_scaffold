# class TwilioController < ApplicationController

#   def text

#       #   sender = params[:From]
#       #   friends = {
#       #     "+18477672332" => "Curious George",
#       #     "+14158157775" => "Boots",
#       #     "+14155551234" => "Virgil"
#       #   }
#       #   name = friends[sender] || "Mobile Monkey"
#       #   twiml = Twilio::TwiML::Response.new do |r|
#       #     r.Message "Hello, #{name}. Thanks for the message."
#       # end
#       # puts twiml.text

#   #     session["counter"] ||= 0

#   #     if params[:Body] == "reset"
#   #       session["counter"] = 0
#   #     end
#   #        sms_count = session["counter"]
#   #     if sms_count == 0
#   #       message = "Welcome to mRelief! We help determine your eligibility for food stamps. How old are you? If you make a mistake, send the message 'reset'."
#   #     end
#   #     if sms_count == 1
#   #       session["age"] = params[:Body]
#   #       message = "How many dependents are in your household? Dependents are the number of people living in your household, including yourself. #{session['counter']}"
#   #     end
#   #     if sms_count == 2
#   #       session["dependents"] = params[:Body]
#   #       message = "What is your gross monthly income? Income includes social security, child support, and unemployment insurance before any deductions."
#   #     end
#   #     if sms_count == 3
#   #       session["income"] = params[:Body]
#   #       #message = "Your income is #{session['income']}. You have #{session['dependents']} dependents. You are #{session['age']} years old."
#   #       age = session["age"].to_i
#   #       snap_dependent_no = session["dependents"].to_i
#   #       snap_gross_income = session["income"].to_i

#   #        if age <= 59
#   #          snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => snap_dependent_no })
#   #        else
#   #          snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => snap_dependent_no })
#   #        end

#   #        if snap_gross_income < snap_eligibility.snap_gross_income
#   #          @eligible = true
#   #        end

#   #         if @eligible == true
#   #           message = "Your income is #{session['income']}. You have #{session['dependents']} dependents. You are #{session['age']} years old. You may be in luck! You likely qualify for foodstamps. Call 311 to find the nearest family community resource center near you."
#   #         end
#   #         if @eligible != true
#   #           message = "Your income is #{session['income']}. You have #{session['dependents']} dependents. You are #{session['age']} years old. Text FOOD to 877-877 to find food near you."
#   #         end
#   #       if sms_count > 3
#   #         message = "Still stuck #{params[:Body]} #{session['counter']}"
#   #       end
#   #     end #this ends sms_count ==3
#   #       twiml = Twilio::TwiML::Response.new do |r|
#   #         r.Message message
#   #       end
#   #     session["counter"] += 1

#   #     respond_to do |format|
#   #       format.xml {render xml: twiml.text}
#   #     end
#   # end


#     session["counter"] ||= 0
#     # session["page"] = "home"
#    if session["counter"] == 0
#     message = "Welcome to mRelief! We help you check your eligibility for benefits. For foodstamps type 'food'. If you make a mistake, send the message 'reset'."
#    end

#    if params[:Body] == "reset" || params[:Body] == "Reset"
#       message = "Welcome to mRelief! We help you check your eligibility for benefits. For foodstamps type 'food'. If you make a mistake, send the message 'reset'."
#    end

#    if params[:Body] == "Food" || params[:Body] == "food"
#       message = "Are you enrolled in a college or institution of higher education?"
#       session["page"] = "snap_college_question"
#    end

#    if session["page"] == "snap_college_question"
#      session["college"] = params[:Body]
#      if session["college"] == "No" || session["college"] == "NO"
#        message = "Are you a citizen of the United States?"
#        session["page"] = "snap_citizen_question"
#      end
#      if session["college"] == "Yes" || session["college"] == "YES" || session["college"] == "yes"
#        session["page"] = "snap_ineligble"
#      end
#    end

#    # if session["page"] == "snap_citizen_question"
#    #   session["citizen"] = params[:Body]
#    #   if session["citizen"] == "no" || session["citizen"] == "No" || session["citizen"] == "NO"
#    #     session["page"] = "snap_ineligble"
#    #   end
#    #   if session["citizen"] == "yes" || session["citizen"] == "Yes" || session["citizen"] == "YES"
#    #     message = "How old are you?"
#    #     session["page"] = "snap_age_question"
#    #   end
#    # end

#    # if session["page"] == "snap_age_question"
#    #   session["age"] = params[:Body]
#    #   message = "What is the number of people living in your household including yourself?"
#    #   session["page"] = "snap_household_question"
#    # end

#    # if session["page"] == "snap_household_question"
#    #   session["dependents"] = params[:Body]
#    #   message = "What is your gross monthly income? Income includes social security, child support, and unemployment insurance before any deductions."
#    #   session["page"] = "snap_income_question"
#    #  end

#    # if session["page"] == "snap_income_question"
#    #   session["income"] = params[:Body]
#    #   age = session["age"].to_i
#    #   snap_dependent_no = session["dependents"].to_i
#    #   snap_gross_income = session["income"].to_i

#    #    if age <= 59
#    #      snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => snap_dependent_no })
#    #    else
#    #      snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => snap_dependent_no })
#    #    end

#    #    if snap_gross_income < snap_eligibility.snap_gross_income
#    #      session["page"] = "snap_eligible"
#    #    else
#    #      session["page"] = "snap_ineligble"
#    #    end
#    # end



#    # #  if session["page"] == "home"
#    # #   message = "Welcome to mRelief! We help you check your eligibility for benefits. For foodstamps type 'food'. If you make a mistake, send the message 'reset'."
#    # # end

#    # if session["page"] == "snap_eligible"
#    #   message = "Your income is #{session['income']}. You have #{session['dependents']} dependents. You are #{session['age']} years old. You may be in luck! You likely qualify for foodstamps. Call 311 to find the nearest family community resource center near you."
#    # end

#    if session["page"] == "snap_ineligble"
#      message = "You likely do not qualify for food stamps"
#      session["counter"] = 0
#    end

#      twiml = Twilio::TwiML::Response.new do |r|
#        r.Message message
#      end

#     session["counter"] += 1

#    respond_to do |format|
#      format.xml {render xml: twiml.text}
#    end

#   end

# end
