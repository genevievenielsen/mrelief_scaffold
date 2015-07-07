class EarlyLearningProgramsController < ApplicationController

	def new
		
	end

	def create
    @d = EarlyLearningData.new

    # Clean Data
		household_size = params[:household_size].strip
    # this is the words into numbers logic
    if household_size !~ /\D/  # returns true if all numbers
      household_size_clean = household_size.to_i
    else
      household_size_clean = household_size.in_numbers
    end
    @d.household_size = household_size_clean


    gross_income = params[:gross_monthly_income].strip
    if gross_income !~ /\D/
      gross_income_clean = gross_income.to_i
    else
      if gross_income.include?("dollars")
        gross_income.slice!"dollars"
      end
      gross_income_clean = gross_income.in_numbers
    end

    @d.gross_monthly_income = gross_income_clean

    # Data Storage
    if params[:zero_to_three].present?
      @d.three_and_under = true
    end
    if params[:three_to_five].present?
      @d.three_to_five = true
    end
    if params[:pregnant].present?
      @d.pregnant = true
    end
    if params[:no_children].present?
      @d.no_children = true
    end

    if params[:foster_parent].present?
      @d.foster_parent = true
    end
    if params[:homeless].present?
      @d.homeless = true
    end
    if params[:ssi].present?
      @d.ssi = true
    end
    if params[:tanf].present?
      @d.tanf = true
    end

    @d.employed = params[:employed]
    @d.higher_education = params[:education]
    @d.zipcode = params[:zipcode]
    @d.preferred_zipcode = params[:preferred_zipcode]
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.save

    if @d.no_children == true
      #user has no children
      @eligible = false
    else
      if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@d.zipcode)
        if @d.three_and_under == true || @d.pregnant == true || @d.three_to_five == true
          under_three_programs = []
          three_to_five_programs = []
          
          if @d.three_and_under == true || @d.pregnant == true 
            under_three_programs = EarlyLearningProgram.where(age_served: '0 - 3')
          end
          if @d.three_to_five == true
            three_to_five_programs = EarlyLearningProgram.where(age_served: '3 - 5')
          end
          correct_age_programs = under_three_programs + three_to_five_programs

          # determine user income type

          correct_income_type_programs = correct_age_programs.where(income_type: user_income_type)

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