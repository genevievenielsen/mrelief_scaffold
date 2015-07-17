require 'twilio-ruby'
class TwilioTestingController < ApplicationController

  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  def text

  session["counter"] ||= 0
  puts session["counter"]
  puts session["page"]

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
    message = "Welcome to mRelief! We help you check your eligibility for public assistance. For foodstamps, text 'food'. For RTA ride free, text 'ride.' For Medicaid, text 'medicaid.' For early learning programs, text 'kids'. If you make a mistake, send the message 'reset'."
   end

   if params[:Body].strip.downcase == "menu"
      message = "For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.' For Early Learning Programs, text the word 'kids'. If you make a mistake, send the message 'reset'."
      session["counter"] = 0
   end
   if params[:Body].strip.downcase == "kids"
      message = "Text the letter(s) that applies to your child by 9/1/15. I care for a child ages: a. 0-2  b. 3-5 c. 6-12. d. none of these Ex: ‘a’ or ‘ab’"
      session["page"] = "age_of_children"
      session["counter"] = 1
   end
  
   
   # HERE IS THE EARLY LEARNING LOGIC
   # number of children question
    if session["page"] == "age_of_children" && session["counter"] == 2
      @user = EarlyLearningDataTwilio.new
      @user.phone_number = params[:From]
      @user.children_ages = params[:Body].strip.downcase

      if @user.children_ages.include?("d")
        @user.no_children = true
        message = "You do not qualify for early learning programs."
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
          message = "Are you pregnant? Enter yes or no" 
          session["page"] = "pregnant"
        else
          message = "In which zipcode do you live? Example: 60615"
          session["page"] = "zipcode"
        end

      else
         message = "Oops looks like there is a typo! Please type a, b, c, d or a cominbation that describes your household."
         session["counter"] = 1
      end
      @user.completed = false
      @user.save
    end

    # Pregnancy question
    if session["page"] == "pregnant" && session["counter"] == 3
      @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
      pregnant = params[:Body].strip.downcase
      session["counter"] += 1 # +1 to optional questions
      # Data Storage
      if pregnant == "yes"
        @user.pregnant == true
      elsif pregnant == "no"
        @user.pregnant == false
      else
        message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
        session["counter"] = 1
      end

      
      message = "In which zipcode do you live? Example: 60615"
      session["page"] = "zipcode"

      @user.completed = false
      @user.save
    end

   # Zipcode question
   if session["page"] == "zipcode" 
    if session["counter"] == 3 || session["counter"] == 5
    @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
    @user.zipcode = params[:Body].strip

    if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
      message = "Are you a foster parent, homeless or does your family receive SSI? Enter yes or no."
      session["page"] = "foster_homeless_ssi"
    else
      # INELIGIBLE
      message = "You do not qualify for Chicago early learning programs."
    end

    @user.completed = false
    @user.save
    end
   end

   # Foster, homeless, SSI question
   if session["page"] == "foster_homeless_ssi" 
    if session["counter"] == 4 || session["counter"] == 6
      @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
      foster_homeless_ssi = params[:Body].strip.downcase
  
      # Data Storage
      if foster_homeless_ssi == "yes"
        @user.foster_homeless_ssi == true
      elsif foster_homeless_ssi == "no"
        @user.foster_homeless_ssi == false
      else
        message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
        session["counter"] = 1
      end
  
  
      message = "What is the number of people living in your household including yourself? Enter a number"
      session["page"] = "household_size"
  
      @user.completed = false
      @user.save
    end
   end


   # Household size question
   if session["page"] == "household_size" 
    if session["counter"] == 5 || session["counter"] == 7
    @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
    household_size = params[:Body].strip
      # Convert to an integer
      if household_size !~ /\D/  # returns true if all numbers
        household_size_cleaned = household_size.to_i
      else
        household_size_cleaned = household_size.in_numbers
      end
      @user.household_size = household_size_cleaned

      message = "What is your gross monthly income? Example - 1000"
      session["page"] = "income"
      @user.completed = false
      @user.save
    end
   end


   # Income question
   if session["page"] == "income" 
    if session["counter"] == 6 || session["counter"] == 8
    @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
    income = params[:Body].strip
      # Convert to an integer
      if income !~ /\D/  # returns true if all numbers
        income_cleaned = income.to_i
      else
        income_cleaned = income.in_numbers
      end
      @user.gross_monthly_income = income_cleaned
      # Determine income eligible programs
      puts "This is the #{@user.household_size}"
      income_row = EarlyLearningIncomeCutoff.find_by(household_size: @user.household_size.to_i)
      puts "This is the income row: #{income_row}"

      @user_income_type = []
      if @user.gross_monthly_income > income_row.income_type2 # Is there a cap?
        @user_income_type = ['Greater than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
        @user_income_type = ['Less than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type1
        @user_income_type = ['Less than Type 1', 'Less than Type 2']
      end

      # Determine correct age programs
      if @user.three_and_under == true || @user.pregnant == true 
        three_and_under_programs = EarlyLearningProgram.where(ages_served: '0 - 2')
        correct_age_programs = three_and_under_programs 
      end        
      if @user.three_to_five == true
        three_to_five_programs = EarlyLearningProgram.where(ages_served: '3 - 5')
        correct_age_programs = three_to_five_programs 
      end
      if three_and_under_programs.present? && three_to_five_programs.present?
        correct_age_programs = EarlyLearningProgram.all
      end 

      @eligible_early_learning_programs = correct_age_programs.where(income_type: @user_income_type)

      message = "Are all adults in your household currently employed? Enter yes or no"
      session["page"] = "employment"
      @user.completed = false
      @user.save
    end
   end

   # Employment question
   if session["page"] == "employment" 
    if session["counter"] == 7 || session["counter"] == 9
     @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
     employment = params[:Body].strip.downcase
     

     if employment == "yes"
       @user.employment == true
       # RESPONSE MESSAGE
       @user.completed = true

     elsif employment == "no"
       @user.employment == false
       session["page"] = "tanf_special_needs"
       message = "Does your family receive TANF or do you care for a special needs child? Enter yes or no"
       @user.completed = false

     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = 1
       @user.completed = false
     end
    
     
     @user.save
    end
   end

   # Tanf and special needs question
   if session["page"] == "tanf_special_needs"
    if session["counter"] == 8 || session["counter"] == 10
     @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
     tanf_special_needs = params[:Body].strip.downcase
     
     # Data Storage
     if tanf_special_needs == "yes"
       @user.tanf_special_needs == true
       # RESPONSE MESSAGE 
       @user.completed = true

     elsif tanf_special_needs == "no"
       @user.tanf_special_needs == false
       session["page"] = "teen_parent"
       message = "Are you a teen parent who is enrolled full-time in school or GED classes or its equivalent? Enter yes or no"
       @user.completed = false
     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = 1
       @user.completed = false
     end

     @user.save
    end
   end


   # Teen parent question
   if session["page"] == "teen_parent"
    if session["counter"] == 9 || session["counter"] == 11
     @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
     teen_parent = params[:Body].strip.downcase
     
     # Data Storage
     if teen_parent == "yes"
       @user.teen_parent == true
     elsif teen_parent == "no"
       @user.teen_parent == false
     else
       message = "Oops looks like there is a typo! Please enter 'yes' or 'no'"
       session["counter"] = 1
     end

     message = "You may be in luck, and likely qualify for Chicago early learning programs. Call (312) 229-1690 or visit bit.ly/XXX for info."

     @user.completed = true
     @user.save
    end
   end


   twiml = Twilio::TwiML::Response.new do |r|
       r.Message message
   end

    session["counter"] += 1
    puts "I made it to the counter"

    respond_to do |format|
     format.xml {render xml: twiml.text}
   end
  end


  include Webhookable

   after_filter :set_header

   skip_before_action :verify_authenticity_token


end