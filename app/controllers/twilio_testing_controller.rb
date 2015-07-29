require 'twilio-ruby'
class TwilioTestingController < ApplicationController

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
    message = "Welcome to mRelief! We help you check your eligibility for public assistance. For early learning programs and child care, text 'kids'. For early learning programs and child care in Spanish, text 'ninos'. For foodstamps, text 'food'. For RTA ride free, text 'ride.' For Medicaid, text 'medicaid.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body].strip.downcase == "menu"
      message = "For early learning programs and child care, text 'kids'. For early learning programs and child care in Spanish, text 'ninos'. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.' If you make a mistake, send the message 'reset'."
      session["counter"] = 0
   end
   if params[:Body].strip.downcase == "kids"
      message = "Text the letter(s) that applies to your child by 9/1/15. I care for a child ages: a. 0-2 b. 3-5 c. 6-12. d. none of these Ex: ‘a’ or ‘ab’"
      session["page"] = "age_of_children"
      session["counter"] = 1
   end

   if params[:Body].strip.downcase == "ninos"
      message = "Escriba las letras que aplican a su hijo antes del 1º de Septiembre de 2015. Yo cuido a un(os) menor(es) entre las edades de: a. 0 a 2  b. 3 a 5 c. 6 a 12. d. Ninguno de estos. Ejemplo: ‘a’ o ‘ab’"
      session["page"] = "age_of_children_es"
      session["counter"] = 1
   end
  
   
   # HERE IS THE EARLY LEARNING LOGIC
   # number of children question
    if session["page"] == "age_of_children" && session["counter"] == 2
      @user = EarlyLearningDataTwilio.new
      @user.phone_number = params[:From]
      @user.children_ages = params[:Body].strip.downcase
      # no children
      if @user.children_ages.include?("d")
        @user.no_children = true
        message = "You may not be eligible for Chicago: Ready to Learn! early learning programs at this time.  Call 312-823-1100 for info on other opportunities."
        @user.completed = true
        @user.save
      # children
      elsif @user.children_ages.include?("a") || @user.children_ages.include?("b") || @user.children_ages.include?("c") 
        # Data storage for children ages
        if @user.children_ages.include?("a")
          @user.three_and_under = true
        end
        if @user.children_ages.include?("b")
          @user.three_to_five = true
        end
        if @user.children_ages.include?("c")
          @user.six_to_twelve = true
        end

        if @user.three_and_under != true
          message = "Are you or your partner pregnant? Enter yes or no. " 
          session["page"] = "pregnant"
        else
          message = "In which zipcode do you live? Example: 60615"
          session["page"] = "zipcode"
        end
        @user.completed = false
        @user.save
      # error 
      else
         message = "Oops looks like there is a typo! Please type a, b, c, d or a cominbation that describes your household."
         session["counter"] = session["counter"] - 1
         @user.completed = false
         @user.save
      end
    end

    # Pregnancy question
    if session["page"] == "pregnant" && session["counter"] == 3
      @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
      pregnant = params[:Body].strip.downcase
      session["counter"] += 1 # +1 to optional questions
      # Data Storage
      if pregnant == "yes"
        @user.pregnant == true
        message = "In which zipcode do you live? Example: 60615"
        session["page"] = "zipcode"

      elsif pregnant == "no"
        @user.pregnant == false
        message = "In which zipcode do you live? Example: 60615"
        session["page"] = "zipcode"

      else
        message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
        session["counter"] = session["counter"] - 1
      end

      @user.completed = false
      @user.save
    end

   # Zipcode question
   if session["page"] == "zipcode" 
    if session["counter"] == 3 || session["counter"] == 5
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    @user.zipcode = params[:Body].strip

    if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
      message = "Are you a foster parent, in a temporary living situation or does your family receive SSI? Enter yes or no"
      session["page"] = "categorical_income_eligibility" 
      @user.completed = false
      @user.save
    else
      # INELIGIBLE
      message = "You may not be eligible for Chicago: Ready to Learn! early learning programs at this time.  Call 312-823-1100 for info on other opportunities."
      @user.completed = true
      @user.save
    end

    end
   end

   # Categorial Income Eligibility 
   if session["page"] == "categorical_income_eligibility" 
    if session["counter"] == 4 || session["counter"] == 6
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    foster_temporary_ssi = params[:Body].strip.downcase

      if foster_temporary_ssi == "yes"
       @user.foster_temporary_ssi == true
       session["page"] = "household_size" 
       message = "What is the number of people living in your household including yourself?"
    
      elsif foster_temporary_ssi == "no"
        @user.foster_temporary_ssi == false
        session["page"] = "household_size" 
        message = "What is the number of people living in your household including yourself?"

      else
        message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
        session["counter"] = session["counter"] - 1
      end
      @user.completed = false
    end
   end

   # Household size question
   if session["page"] == "household_size" 
    if session["counter"] == 5 || session["counter"] == 7
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    household_size = params[:Body].strip
      # Convert to an integer
      if household_size !~ /\D/  # returns true if all numbers
        household_size_cleaned = household_size.to_i
      else
        household_size_cleaned = household_size.in_numbers
      end
      @user.household_size = household_size_cleaned.to_i
      @user.save

      message = "What is your gross total monthly income before taxes? Example - 1000"
      session["page"] = "income"
      @user.completed = false
      @user.save
    end
   end

   # Income question
   if session["page"] == "income" 
    if session["counter"] == 6 || session["counter"] == 8
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    income = params[:Body].strip
      # Convert to an integer
      if income !~ /\D/  # returns true if all numbers
        income_cleaned = income.to_i
      else
        income_cleaned = income.in_numbers
      end
      @user.gross_monthly_income = income_cleaned.to_f
      # Determine income eligible programs
      income_row = EarlyLearningIncomeCutoff.find_by(household_size: @user.household_size.to_i)

      @user_income_type = []
      if @user.gross_monthly_income > income_row.income_type2 # Notice about co-pay?
        @user_income_type = ['Greater than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
        @user_income_type = ['Less than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type1
        @user_income_type = ['Less than Type 1', 'Less than Type 2']
      end
      @user.income_type = @user_income_type.try(:to_s)

      message = "Are all adults in your household currently employed? Enter yes or no"
      session["page"] = "employment"
      @user.early_learning_eligible = true
      @user.completed = false
      @user.save
    end
   end

   # Employment question
   if session["page"] == "employment" 
    if session["counter"] == 7 || session["counter"] == 9
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     employment = params[:Body].strip.downcase
     
     if employment == "yes"
       @user.employment == true
       # RESPONSE MESSAGE
       # CCAP eligible if below income cutoff 
        income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})
        if @user.gross_monthly_income < income_row.income_type4
          @user.ccap_eligible = true
          # child is ineligibe for early learning but eligible is ccap
          if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
          message = "You likely qualify for the Child Care Assistance Program! Based on your child's age and other factors you do not qualify for early learning programs, but please call Illinois Action For Children Community Referral Team at 312-823-1100 for more information."
          # child is eligible for early learning and ccap
          else
          message = "You likely qualify for Chicago early learning programs. You also may be eligible for the Child Care Assistance Program. To enroll call (312) 229-1690 or visit bit.ly/learnearly for info."
          end
           @user.completed = true
        else
          session["page"] = "tanf_special_needs"
          message = "Does your family receive TANF or do you care for a child with special needs or an individualized education plan (IEP)? Enter yes or no."
          @user.completed = false
        end
        
     elsif employment == "no"
       @user.employment == false
       session["page"] = "tanf_special_needs"
       message = "Does your family receive TANF or do you care for a child with special needs or an individualized education plan (IEP)? Enter yes or no."
       @user.completed = false

     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = session["counter"] - 1
       @user.completed = false
     end
    
     @user.save
    end
   end

   # Tanf and special needs question
   if session["page"] == "tanf_special_needs"
    if session["counter"] == 8 || session["counter"] == 10
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     tanf_special_needs = params[:Body].strip.downcase
     
     # Data Storage
     if tanf_special_needs == "yes"
       @user.tanf_special_needs == true
       # Eligible for CCAP
       # Child is ineligibe for early learning but eligible is CCAP
       if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
        message = "You likely qualify for the Child Care Assistance Program! Based on your child's age and other factors you do not qualify for early learning programs, but please call Illinois Action For Children Community Referral Team at 312-299-1690 for more information."
       # child is eligible for early learning and ccap
       else
        message = "You likely qualify for Chicago early learning programs. You also may be eligible for the Child Care Assistance Program. To enroll call (312) 229-1690 or visit bit.ly/learnearly for info."
       end
        @user.completed = true

     elsif tanf_special_needs == "no"
       @user.tanf_special_needs == false
       session["page"] = "teen_parent"
       message = "Are you a teen parent who is enrolled full-time in school or GED classes or its equivalent? Enter yes or no"
       @user.completed = false
     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = session["counter"] - 1
       @user.completed = false
     end

     @user.save
    end
   end

   # Teen parent question
   if session["page"] == "teen_parent"
    if session["counter"] == 9 || session["counter"] == 11
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     teen_parent = params[:Body].strip.downcase
     
     # Data Storage
     if teen_parent == "yes"
       # RESPONSE MESSAGE
       # eligible for CCAP
       if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
       message = "You likely qualify for the Child Care Assistance Program! Based on your child's age and other factors you do not qualify for early learning programs, but please call Illinois Action For Children Community Referral Team at 312-823-1100 for more information."
       # child is eligible for early learning and ccap
       else
       message = "You likely qualify for Chicago early learning programs! You also may be eligible for the Child Care Assistance Program. To enroll call (312) 229-1690 or visit bit.ly/learnearly for info."
       end
       @user.teen_parent == true
       @user.ccap_eligible = true
       @user.completed = true
     elsif teen_parent == "no"
       @user.teen_parent == false
        
        if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
          message = "Based on your child's age and other factors, you do not qualify for early learning programs and child care assistance at this time.  Call 312-823-1100 for information on other opportunities."
        # eligible for early learning 
        else  
          # eligble for early learning with co-pay
          if @user.income_type == "[\"Greater than Type 2\"]"
           message = "You likely qualify for Chicago early learning programs! Call (312) 229-1690 or visit bit.ly/learnearly for info. Note: Based on your income, you may have some additional fees. Calculate your estimated co-pay here."
          # eligible for early learning with no co-pay
          else
            message = "You likely qualify for Chicago early learning programs! Call (312) 229-1690 or visit bit.ly/learnearly for info."
          end
        @user.completed = true
        end
     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = session["counter"] - 1
       @user.completed = false
     end
     @user.save
    end
   end


   # HERE IS THE EARLY LEARNING SPANISH LOGIC
   # number of children question
    if session["page"] == "age_of_children_es" && session["counter"] == 2
      @user = EarlyLearningDataTwilio.new
      @user.phone_number = params[:From]
      @user.children_ages = params[:Body].strip.downcase
      # no children
      if @user.children_ages.include?("d")
        @user.no_children = true
        message = "You may not be eligible for Chicago: Ready to Learn! early learning programs at this time.  Call 312-823-1100 for info on other opportunities."
        @user.completed = true
        @user.save
      # children
      elsif @user.children_ages.include?("a") || @user.children_ages.include?("b") || @user.children_ages.include?("c") 
        # Data storage for children ages
        if @user.children_ages.include?("a")
          @user.three_and_under = true
        end
        if @user.children_ages.include?("b")
          @user.three_to_five = true
        end
        if @user.children_ages.include?("c")
          @user.six_to_twelve = true
        end

        if @user.three_and_under != true
          message = "Are you or your partner pregnant? Enter yes or no." 
          session["page"] = "pregnant_es"
        else
          message = "In which zipcode do you live? Example: 60615"
          session["page"] = "zipcode_es"
        end
        @user.completed = false
        @user.save
      # error 
      else
         message = "Oops looks like there is a typo! Please type a, b, c, d or a cominbation that describes your household."
         session["counter"] = session["counter"] - 1
         @user.completed = false
         @user.save
      end
    end

    # Pregnancy question
    if session["page"] == "pregnant_es" && session["counter"] == 3
      @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
      pregnant = params[:Body].strip.downcase
      session["counter"] += 1 # +1 to optional questions
      # Data Storage
      if pregnant == "yes"
        @user.pregnant == true
        message = "In which zipcode do you live? Example: 60615"
        session["page"] = "zipcode_es"

      elsif pregnant == "no"
        @user.pregnant == false
        message = "In which zipcode do you live? Example: 60615"
        session["page"] = "zipcode_es"

      else
        message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
        session["counter"] = session["counter"] - 1
      end

      @user.completed = false
      @user.save
    end

   # Zipcode question
   if session["page"] == "zipcode_es" 
    if session["counter"] == 3 || session["counter"] == 5
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    @user.zipcode = params[:Body].strip

    if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
      message = "Are you a foster parent, in a temporary living situation or does your family receive SSI? Enter yes or no"
      session["page"] = "categorical_income_eligibility_es" 
      @user.completed = false
      @user.save
    else
      # INELIGIBLE
      message = "You may not be eligible for Chicago: Ready to Learn! early learning programs at this time.  Call 312-823-1100 for info on other opportunities."
      @user.completed = true
      @user.save
    end

    end
   end

   # Categorial Income Eligibility 
   if session["page"] == "categorical_income_eligibility_es" 
    if session["counter"] == 4 || session["counter"] == 6
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    foster_temporary_ssi = params[:Body].strip.downcase

      if foster_temporary_ssi == "yes"
       @user.foster_temporary_ssi == true
       session["page"] = "household_size_es" 
       message = "What is the number of people living in your household including yourself?"
    
      elsif foster_temporary_ssi == "no"
        @user.foster_temporary_ssi == false
        session["page"] = "household_size_es" 
        message = "What is the number of people living in your household including yourself?"

      else
        message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
        session["counter"] = session["counter"] - 1
      end
      @user.completed = false
    end
   end

   # Household size question
   if session["page"] == "household_size_es" 
    if session["counter"] == 5 || session["counter"] == 7
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    household_size = params[:Body].strip
      # Convert to an integer
      if household_size !~ /\D/  # returns true if all numbers
        household_size_cleaned = household_size.to_i
      else
        household_size_cleaned = household_size.in_numbers
      end
      @user.household_size = household_size_cleaned.to_i
      @user.save

      message = "What is your gross total monthly income before taxes? Example - 1000"
      session["page"] = "income_es"
      @user.completed = false
      @user.save
    end
   end

   # Income question
   if session["page"] == "income_es" 
    if session["counter"] == 6 || session["counter"] == 8
    @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
    income = params[:Body].strip
      # Convert to an integer
      if income !~ /\D/  # returns true if all numbers
        income_cleaned = income.to_i
      else
        income_cleaned = income.in_numbers
      end
      @user.gross_monthly_income = income_cleaned.to_f
      # Determine income eligible programs
      income_row = EarlyLearningIncomeCutoff.find_by(household_size: @user.household_size.to_i)

      @user_income_type = []
      if @user.gross_monthly_income > income_row.income_type2 # Notice about co-pay?
        @user_income_type = ['Greater than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
        @user_income_type = ['Less than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type1
        @user_income_type = ['Less than Type 1', 'Less than Type 2']
      end
      @user.income_type = @user_income_type.try(:to_s)

      message = "Are all adults in your household currently employed? Enter yes or no"
      session["page"] = "employment_es"
      @user.early_learning_eligible = true
      @user.completed = false
      @user.save
    end
   end

   # Employment question
   if session["page"] == "employment_es" 
    if session["counter"] == 7 || session["counter"] == 9
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     employment = params[:Body].strip.downcase
     
     if employment == "yes"
       @user.employment == true
       # RESPONSE MESSAGE
       # CCAP eligible if below income cutoff 
        income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})
        if @user.gross_monthly_income < income_row.income_type4
          @user.ccap_eligible = true
          # child is ineligibe for early learning but eligible is ccap
          if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
          message = "You likely qualify for the Child Care Assistance Program! Based on your child's age and other factors you do not qualify for early learning programs, but please call Illinois Action For Children Community Referral Team at 312-823-1100 for more information."
          # child is eligible for early learning and ccap
          else
          message = "You likely qualify for Chicago early learning programs. You also may be eligible for the Child Care Assistance Program. To enroll call (312) 229-1690 or visit bit.ly/learnearly for info."
          end
           @user.completed = true
        else
          session["page"] = "tanf_special_needs_es"
          message = "Does your family receive TANF or do you care for a child with special needs or an individualized education plan (IEP)? Enter yes or no."
          @user.completed = false
        end
        
     elsif employment == "no"
       @user.employment == false
       session["page"] = "tanf_special_needs_es"
       message = "Does your family receive TANF or do you care for a child with special needs or an individualized education plan (IEP)? Enter yes or no."
       @user.completed = false

     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = session["counter"] - 1
       @user.completed = false
     end
    
     @user.save
    end
   end

   # Tanf and special needs question
   if session["page"] == "tanf_special_needs_es"
    if session["counter"] == 8 || session["counter"] == 10
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     tanf_special_needs = params[:Body].strip.downcase
     
     # Data Storage
     if tanf_special_needs == "yes"
       @user.tanf_special_needs == true
       # Eligible for CCAP
       # Child is ineligibe for early learning but eligible is CCAP
       if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
        message = "You likely qualify for the Child Care Assistance Program! Based on your child's age and other factors you do not qualify for early learning programs, but please call Illinois Action For Children Community Referral Team at 312-299-1690 for more information."
       # child is eligible for early learning and ccap
       else
        message = "You likely qualify for Chicago early learning programs. You also may be eligible for the Child Care Assistance Program. To enroll call (312) 229-1690 or visit bit.ly/learnearly for info."
       end
        @user.completed = true

     elsif tanf_special_needs == "no"
       @user.tanf_special_needs == false
       session["page"] = "teen_parent_es"
       message = "Are you a teen parent who is enrolled full-time in school or GED classes or its equivalent? Enter yes or no"
       @user.completed = false
     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = session["counter"] - 1
       @user.completed = false
     end

     @user.save
    end
   end

   # Teen parent question
   if session["page"] == "teen_parent_es"
    if session["counter"] == 9 || session["counter"] == 11
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     teen_parent = params[:Body].strip.downcase
     
     # Data Storage
     if teen_parent == "yes"
       # RESPONSE MESSAGE
       # eligible for CCAP
       if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
       message = "You likely qualify for the Child Care Assistance Program! Based on your child's age and other factors you do not qualify for early learning programs, but please call Illinois Action For Children Community Referral Team at 312-823-1100 for more information."
       # child is eligible for early learning and ccap
       else
       message = "You likely qualify for Chicago early learning programs! You also may be eligible for the Child Care Assistance Program. To enroll call (312) 229-1690 or visit bit.ly/learnearly for info."
       end
       @user.teen_parent == true
       @user.ccap_eligible = true
       @user.completed = true
     elsif teen_parent == "no"
       @user.teen_parent == false
        
        if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
          message = "Based on your child's age and other factors, you do not qualify for early learning programs and child care assistance at this time.  Call 312-823-1100 for information on other opportunities."
        # eligible for early learning 
        else  
          # eligble for early learning with co-pay
          if @user.income_type == "[\"Greater than Type 2\"]"
           message = "You likely qualify for Chicago early learning programs! Call (312) 229-1690 or visit bit.ly/learnearly for info. Note: Based on your income, you may have some additional fees. Calculate your estimated co-pay here."
          # eligible for early learning with no co-pay
          else
            message = "You likely qualify for Chicago early learning programs! Call (312) 229-1690 or visit bit.ly/learnearly for info."
          end
        @user.completed = true
        end
     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = session["counter"] - 1
       @user.completed = false
     end
     @user.save
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


  include Webhookable

   after_filter :set_header

   skip_before_action :verify_authenticity_token


end