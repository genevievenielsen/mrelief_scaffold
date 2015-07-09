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
    if params[:employment] == "yes"
      @user.employed = true
    end
    if params[:education] == "yes"
      @user.higher_education = true
    end
    @user.zipcode = params[:zipcode]
    @user.preferred_zipcode = params[:preferred_zipcode]
    @user.phone_number = params[:phone_number] if params[:phone_number].present?
    @user.save

    # data storage to add

    # income type
    # program eligibility 
    # teen_parent: boolean
    # six_to_twelve: boolean
    # special_needs: boolean
    # - eligible
    # - eligible_count

    if @user.no_children == true
      # user has no children
      @eligible = false
    else
      # determine if user lives in correct zipcode
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
              # Type 1 and Type 2 
              user_income_type = 'Type 1'  
            end

            # find programs with correct age and income requirements
            @correct_income_type_programs = correct_age_programs.where(income_type: user_income_type)

            @eligible_early_learning_programs = []

            # Must answer yes to one of the two questions: Are you currently employed?Are you enrolled in college/institution of higher education?
            if @user.employed == true || @user.higher_education == true
              employed_or_education_programs = @correct_income_type_programs.where(additional_criteria: "employed or in education")
              @eligible_early_learning_programs += employed_or_education_programs
              puts "I made it to employment or education"
            end
            # Must select either foster care or homelessness to be automatically eligible
            if @user.foster_parent == true || @user.homeless == true
              foster_or_homeless_programs = @correct_income_type_programs.where(additional_criteria: "foster care or homeless")
              @eligible_early_learning_programs += foster_or_homeless_programs
              puts "I made it to foster or homeless"
            end
            # Automatically eligible if in foster care, homeless, family receives SSI, family receives TANF
            if @user.foster_parent == true || @user.homeless == true || @user.ssi == true || @user.tanf == true
              foster_homeless_ssi_tanf_programs = @correct_income_type_programs.where(additional_criteria: "foster care, homeless, ssi or tanf")
              @eligible_early_learning_programs += foster_homeless_ssi_tanf_programs
              puts "I made it to foster, homeless, ssi or tanf"
            end

            if @eligible_early_learning_programs.length > 0
              @eligible = true

              # if @eligible_early_learning_programs.each do |program|
                
              # end

            else
              @eligible = false
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