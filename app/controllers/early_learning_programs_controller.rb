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
    if params[:none_of_the_above].present?
      @user.none_of_the_above = true
    end

    # yes or no questions
    @user.employed = params[:employment] 
    @user.health_status = params[:health_status]
    @user.other_zipcode = params[:other_zipcode]
    @user.bilingual = params[:bilingual]
    @user.bilingual_language = params[:bilingual_language]
    @user.preferred_frequency = params[:preferred_frequency]

    @user.zipcode = params[:zipcode]
    @user.preferred_zipcode = params[:preferred_zipcode]
    @user.phone_number = params[:phone_number] if params[:phone_number].present?
    
    if params[:preferred_duration].include?("(")
      preferred_duration = params[:duration].split("(").first.strip
      @user.preferred_duration = preferred_duration
    else
      @user.preferred_duration = params[:preferred_duration]
    end
    @user.save


    if @user.no_children == true
      # user has no children
      @eligible = false
    else
      if @user.household_size == 1 && @user.pregnant == false
        # user has a household size of 1 and is not pregant
        @eligible = false
      else
        # determine if user lives in correct zipcode
        if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
          if @user.three_and_under == true || @user.pregnant == true || @user.three_to_five == true
            
            # determine correct ages - returns correct_age_programs
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

              # Eligible prgrams based on criteria and income - returns @eligible_early_learning_programs
              if @user.foster_parent == true || @user.homeless == true || @user.ssi == true || @user.tanf == true
      
                if @user.foster_parent == true || @user.homeless == true
                  additional_criteria = ["foster care, homeless, ssi or tanf", "foster care or homeless"]
                  @eligible_early_learning_programs = correct_age_programs.where(additional_criteria: additional_criteria)

                else
                  @eligible_early_learning_programs = correct_age_programs.where(additional_criteria: "foster care, homeless, ssi or tanf")
                  puts "I made it here" 
                  puts "#{@eligible_early_learning_programs.count}"
                end
            
              else
              # User is not automatically eligible 
                income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})

                @user_income_type = []
                  if @user.gross_monthly_income > income_row.income_type2 # Is there a cap?
                    @user_income_type = ['Greater than Type 2']
                  elsif @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
                    @user_income_type = ['Less than Type 2']
                  elsif @user.gross_monthly_income <= income_row.income_type1
                    # Type 1 and Type 2 
                    @user_income_type = ['Less than Type 1', 'Less than Type 2']
                  end

                  @eligible_early_learning_programs = correct_age_programs.where(income_type: @user_income_type)
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
      end # ends household size 1 and not pregnant
    end # ends user has no children

    # Additional Data Storage
    if @eligible == false
    else
      @user.income_type = @user_income_type.try(:to_s)
      @eligible_descriptions = @eligible_early_learning_programs.pluck(:description)
      if @eligible_descriptions.include?("Head Start - Childcare Collaboration")
        @user.head_start_childcare_collaboration = true
      end
      if @eligible_descriptions.include?("Head Start - Preschool - Childcare Collaboration")
        @user.head_start_preschool_childcare_collaboration = true 
      end
      if @eligible_descriptions.include?("Preschool for All - Childcare Collaboration")
        @user.preschool_for_all_childcare_collaboration = true 
      end
      if @eligible_descriptions.include?("Prevention Initiative - Home Visiting - 0 to 2")
        @user.prevention_initiative_home_visiting_0to2 = true 
      end
      if @eligible_descriptions.include?("School Based - No Co-Pay - Full Day")
        @user.school_based_no_co_pay_full_day = true 
      end
      if @eligible_descriptions.include?("School Based - No Co-Pay - Half Day")
        @user.school_based_no_co_pay_half_day = true 
      end
      if @eligible_descriptions.include?("School Based - Co-Pay - Full Day")
        @user.school_based_co_pay_full_day = true 
      end
      if @eligible_descriptions.include?("School Based - Co-Pay - Half Day")
        @user.school_based_co_pay_half_day = true 
      end
      if @eligible_descriptions.include?("Head Start - Center Based - Half Day - 3 to 5")
        @user.head_start_center_based_half_day_3to5 = true 
      end
      if @eligible_descriptions.include?("Early Head Start - Childcare Collaboration")
        @user.early_head_start_childcare_collaboration = true 
      end
      if @eligible_descriptions.include?("Prevention Initiative - Childcare Collaboration")
        @user.prevention_initiative_childcare_collaboration = true 
      end
      if @eligible_descriptions.include?("Early Head Start - Home Visiting - 0 to 2")
        @user.early_head_start_home_visiting_0to2 = true 
      end
      if @eligible_descriptions.include?("Head Start - Home Visting - 3 to 5")
        @user.head_start_home_visting_3to5 = true 
      end 
      if @eligible_descriptions.include?("Head Start - School Based - Half Day - 3 to 5")
        @user.head_start_school_based_half_day_3to5 = true 
      end 
      if @eligible_descriptions.include?("Head Start - School Based - Full Day - 3 to 5")
        @user.head_start_school_based_full_day_3to5 = true 
      end 
      @user.eligible_count = @eligible_early_learning_programs.count
      @user.save
    end

    # WIC ELIGIBILITY
    if @user.health_status == "yes"
      if @user.pregnant == true || @user.three_and_under == true || @user.three_to_five == true
        if @user.snap_or_medicaid == true || @user.tanf == true
          @wic_eligible = true
        else
          income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})
          if @user.gross_monthly_income < income_row.income_type3
            @wic_eligible = true
          else
            @wic_eligible = false
          end
        end
      else
      # no children
        @wic_eligible = false
      end
    else
      # ineligible health status
      @wic_eligible = false
    end
    if @wic_eligible == true
      @user.wic_eligible = true
    else
      @user.wic_eligible = false
    end 

    # CCAP ELIGIBILITY
      if @user.tanf == true || @user.teen_parent == true || @user.special_needs == true
        if @user.three_and_under == true || @user.pregnant == true || @user.three_to_five == true || @user.six_to_twelve == true
          if @user.employed == "yes" 
            income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})
            if @user.gross_monthly_income < income_row.income_type4
              @ccap_eligible = true
            else
               @ccap_eligible = false
            end
          else
            # not employed 
            @ccap_eligible = false
          end
        else
          # no children 
          @ccap_eligible = false
        end
      else
        @ccap_eligible = false
      end
             
 
    if @ccap_eligible == true
      @user.ccap_eligible = true
    else
      @user.ccap_eligible = false
    end
    @user.save 


    if params[:health_status].present? && params[:employment].present? && params[:other_zipcode] && params[:preferred_duration]
      
      if params[:zero_to_three].present? || params[:three_to_five].present? || params[:six_to_twelve].present? || params[:pregnant].present? || params[:no_children].present?
    
        if params[:foster_parent].present? || params[:homeless].present? || params[:ssi].present? || params[:tanf].present? || params[:snap_or_medicaid].present? || params[:teen_parent].present? || params[:special_needs].present? || params[:none_of_the_above].present?

        else
          flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
          render "new"
        end

      else
        flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
        render "new"
      end

    else
      flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
      render "new"
    end       
	end # closes the method

  def more_results
    @user = EarlyLearningData.find(params[:id])
  end
end # closes the class