class EarlyLearningProgramsController < ApplicationController

	def new
		
	end

	def create
    @user = EarlyLearningData.new

    # Clean Data
		household_size = params[:household_size].strip
    # this is the words into numbers logic
    if household_size !~ /\D/  # returns true if all numbers
      household_size_clean = household_size.to_i
    else
      household_size_clean = household_size.in_numbers
    end
    @user.household_size = household_size_clean


    gross_income = params[:gross_monthly_income].strip
    if gross_income !~ /\D/
      gross_income_clean = gross_income.to_i
    else
      if gross_income.include?("dollars")
        gross_income.slice!"dollars"
      end
      gross_income_clean = gross_income.in_numbers
    end
    @user.gross_monthly_income = gross_income_clean

    # Data Storage
    if params[:zero_to_three].present?
      @user.three_and_under = true
    end
    if params[:three_to_five].present?
      @user.three_to_five = true
    end
    if params[:pregnant].present?
      @user.pregnant = true
    end
    if params[:no_children].present?
      @user.no_children = true
    end

    if params[:foster_parent].present?
      @user.foster_parent = true
    end
    if params[:homeless].present?
      @user.homeless = true
    end
    if params[:ssi].present?
      @user.ssi = true
    end
    if params[:tanf].present?
      @user.tanf = true
    end

    @user.employed = params[:employed]
    @user.higher_education = params[:education]
    @user.zipcode = params[:zipcode]
    @user.preferred_zipcode = params[:preferred_zipcode]
    @user.phone_number = params[:phone_number] if params[:phone_number].present?
    @user.save

    # data storage to add
    # income type 

    if @user.no_children == true
      #user has no children
      @eligible = false
    else
      if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
        if @user.three_and_under == true || @user.pregnant == true || @user.three_to_five == true
          
          # determine correct ages 
          if @user.three_and_under == true || @user.pregnant == true 
            three_and_under_programs = EarlyLearningProgram.where(ages_served: '0 - 3')
            correct_age_programs = three_and_under_programs
            puts "I made it to 0 to 3"  
          end        

          if @user.three_to_five == true
            three_to_five_programs = EarlyLearningProgram.where(ages_served: '3 - 5')
            correct_age_programs = three_to_five_programs
            puts "I made it to 3 to 5"  
          end
        
          if three_and_under_programs.present? && three_to_five_programs.present?
            correct_age_programs = EarlyLearningProgram.all
            puts "I made it to all ages"
          end 

          # determine user income type
          income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})

          if @user.gross_monthly_income > income_row.income_type2
            # user income exceeds income cutoff
            @eligible = false
          else

            if @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
              user_income_type = 'Type 2'
            elsif @user.gross_monthly_income <= income_row.income_type1
              user_income_type = 'Type 1'  
            end

            @correct_income_type_programs = correct_age_programs.where(income_type: user_income_type)

            @eligible_programs = []

            if @user.employed == "yes" || @user.higher_education == "yes"
              
            end

          end
        else
          # user does not have a child of the correct age
          @eligible = false
        end
      else
        # user does not live in Chicago zipcodes
        @eligible = false
      end
    end


		

	end
end