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
    message = "Welcome to mRelief! We help you check your eligibility for public assistance. For foodstamps, text 'food'. For RTA ride free, text 'ride.' For Medicaid, text 'medicaid.' For Medicare Cost Sharing, text 'medicare.' If you make a mistake, send the message 'reset'."
   end

   if params[:Body].strip.downcase == "menu"
      message = "For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.' For Early Learning Programs, text the word 'kids'. If you make a mistake, send the message 'reset'."
      session["counter"] = 0
   end
   if params[:Body].strip.downcase == "kids"
      message = "Text the letters that apply to you. - a) Child between 0-2 years b) Child between 3-5 years c) Children between 6-12 years d) Pregant e) No Children. For example, b or ac."
      session["page"] = "age_of_children"
      session["counter"] = 1
   end
  
   
   # HERE IS THE EARLY LEARNING LOGIC
   # number of children question
    if session["page"] == "age_of_children" && session["counter"] == 2
      @user = EarlyLEarningDataTwilio.new
      @user.phone_number = params[:From]
      @user.children_ages = params[:Body].strip.downcase

      if @user.children_ages.include?("e")
        @user.no_children = true
        message = "You do not qualify for early learning programs."
      elsif @user.children_ages.include?("a") || @user.children_ages.include?("b") || @user.children_ages.include?("c") || @user.children_ages.include?("d")
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
        if @user.children_ages.include?("d")
          @user.pregnant = true
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

        session["page"] = "zipcode"
        message = "What is your zipcode?"
      else
         message = "Oops looks like there is a typo! Please type a, b, c, d or e cominbation that describes your household."
         session["counter"] = 1
      end
      @user.completed = false
      @user.save
    end

   # Zipcode question
   if session["page"] == "zipcode" 
    @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
    @user.zipcode = params[:Body].strip

    if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
      message = 
      session["page"] = 
    else
      message = "You do not qualify for Chicago early learning programs."
    end

    @s.completed = false
    @s.save
   
   end


  message = "What is the number of people living in your household including yourself? Enter a number"
   # Household size question
   if session["page"] == "household_size" 
    @user = EarlyLearningDataTwilio.find_or_create_by(:phone_number => params[:From], :completed => false)
    household_size = params[:Body].strip
      # Convert to an integer
      if household_size !~ /\D/  # returns true if all numbers
        household_size_cleaned = household_size.to_i
      else
        household_size_cleaned = household_size.in_numbers
      end
      @user.household_size = household_size_cleaned

      message = 
      session["page"] = 
      @s.completed = false
      @s.save
   
   end


   # Income question
   if session["page"] == "income" 
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
      @user_income_type = []
      if @user.gross_monthly_income > income_row.income_type2 # Is there a cap?
        @user_income_type = ['Greater than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
        @user_income_type = ['Less than Type 2']
      elsif @user.gross_monthly_income <= income_row.income_type1
        @user_income_type = ['Less than Type 1', 'Less than Type 2']
      end
      @eligible_early_learning_programs = correct_age_programs.where(income_type: @user_income_type)


      message = 
      session["page"] = 
      @s.completed = false
      @s.save
   
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