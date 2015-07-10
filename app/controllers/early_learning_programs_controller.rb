class EarlyLearningProgramsController < ApplicationController

	def new
		@user = EarlyLearningData.new
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
    # age 
    if params[:zero_to_three].present?
      @user.three_and_under = true
    end
    if params[:three_to_five].present?
      @user.three_to_five = true
    end
    if params[:six_to_twelve].present?
      @user.six_to_twelve = true
    end
    if params[:pregnant].present?
      @user.pregnant = true
    end
    if params[:no_children].present?
      @user.no_children = true
    end

    # select all
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
    if params[:snap_or_medicaid].present?
      @user.snap_or_medicaid = true
    end
    if params[:teen_parent].present?
      @user.teen_parent = true
    end
    if params[:special_needs].present?
      @user.special_needs = true
    end

    # yes or no questions
    if params[:employment] == "yes"
      @user.employed = true
    end
    if params[:education] == "yes"
      @user.higher_education = true
    end
    if params[:other_zipcode] == "yes"
      @user.other_zipcode = true
    end
    if params[:health_status] == "yes"
      @user.health_status = true
    end
    @user.zipcode = params[:zipcode]
    @user.preferred_zipcode = params[:preferred_zipcode]
    @user.phone_number = params[:phone_number] if params[:phone_number].present?
    @user.preferred_duration = params[:preferred_duration]
    @user.save


    if @user.no_children == true
      # user has no children
      @eligible = false
    else
      # determine if user lives in correct zipcode
      if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
        if @user.three_and_under == true || @user.pregnant == true || @user.three_to_five == true
          
          # determine correct ages - returns correct_age_programs
          if @user.three_and_under == true || @user.pregnant == true 
            three_and_under_programs = EarlyLearningProgram.where(ages_served: '0 - 3')
            correct_age_programs = three_and_under_programs  
          end        

          if @user.three_to_five == true
            three_to_five_programs = EarlyLearningProgram.where(ages_served: '3 - 5')
            correct_age_programs = three_to_five_programs 
          end
        
          if three_and_under_programs.present? && three_to_five_programs.present?
            correct_age_programs = EarlyLearningProgram.all
          end 

            # Eligible prgrams based on criteria and income - returns @eligible_early_learning_programs

            # Automatically eligible if in foster care, homeless, family receives SSI, family receives TANF
            if @user.foster_parent == true || @user.homeless == true || @user.ssi == true || @user.tanf == true
      
              if @user.foster_parent == true || @user.homeless == true
                additional_criteria = ["foster care, homeless, ssi or tanf", "foster care or homeless"]
                @eligible_early_learning_programs = correct_age_programs.where(additional_criteria: additional_criteria)

              else
                @eligible_early_learning_programs = correct_age_programs.where(additional_criteria: "foster care, homeless, ssi or tanf")
              end
          
            else
            # User is not automatically eligible 
              income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})

              user_income_type = []
                if @user.gross_monthly_income > income_row.income_type2 # Is there a cap
                  user_income_type = ['Greater than Type 2']
                elsif @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
                  user_income_type = ['Less than Type 2']
                elsif @user.gross_monthly_income <= income_row.income_type1
                  # Type 1 and Type 2 
                  user_income_type = ['Less than Type 1', 'Less than Type 2']
                end

                @eligible_early_learning_programs = correct_age_programs.where(income_type: user_income_type)
            end

            # Preferred Early Learning Programs
            if @eligible_early_learning_programs.count > 1
              @preferred_early_learning_programs = @eligible_early_learning_programs.where(duration: @user.preferred_duration)
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

    # Data storage to add

    # income type
    # head_start_childcare_collaboration
    # head_start_preschool_childcare_collaboration
    # preschool_for_all_childcare_collaboration
    # prevention_initiative_home_visiting_0to2
    # school_based_no_co_pay_full_day
    # school_based_no_co_pay_half_day
    # school_based_co_pay_full_day
    # school_based_co_pay_half_day
    # head_start_center_based_half_day_3to5
    # early_head_start_childcare_collaboration
    # prevention_initiative_childcare_collaboration
    # early_head_start_home_visiting_0to2
    # head_start_home_visting_3to5
    # head_start_school_based_half_day_3to5
    # head_start_school_based_full_day_3to5
    # eligible_count



	end
end