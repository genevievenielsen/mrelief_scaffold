class EarlyLearningProgramsController < ApplicationController
  require 'open-uri'
  require 'json'  

	def new
		@user = EarlyLearningData.new
	end

	def create
    # TO DO 
    # - save center keys that we refer people to 
    # - ccap messages
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
    # remove this
    # @user.health_status = params[:health_status]
    @user.other_zipcode = params[:other_zipcode]
    @user.bilingual = params[:bilingual]
    @user.bilingual_language = params[:bilingual_language]
    @user.preferred_frequency = params[:preferred_frequency]

    @user.zipcode = params[:zipcode]
    @user.preferred_zipcode = params[:preferred_zipcode]
    @user.phone_number = params[:phone_number] if params[:phone_number].present?
    @user.preferred_duration = params[:preferred_duration]
    @user.save

    # ELIGIBILITY DETERMINATION
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
                  puts "#{@eligible_early_learning_programs.count}"
                end
            
              else
              # User is not automatically income seligible 
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

    # ADDITIONAL DATA STORAGE
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

    # LOOKS UP IN DATA PORTAL
    if @eligibile == false
    else
      url = "https://data.cityofchicago.org/resource/ck29-hb9r.json"
      raw_data = open(url).read
      parsed_data = JSON.parse(raw_data)
      @all_eligible_locations = []

      # ADD AGE FILERS HERE 

      # Eligible Programs
      parsed_data.each do |location|
        if @user.head_start_childcare_collaboration == true || @user.head_start_preschool_childcare_collaboration == true 
          if location["program_information"].include?("Head Start") && location["program_information"].exclude?("CPS Based") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end

        if @user.preschool_for_all_childcare_collaboration == true 
          if location["program_information"].exclude?("Head Start") && location["program_information"].exclude?("CPS Based") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end

        if @user.prevention_initiative_home_visiting_0to2 == true 
          if location["program_information"].include?("Home Visiting") && location["program_information"].exclude?("Head Start") && location["program_information"].exclude?("Early Head Start") 
            @all_eligible_locations.push(location)
          end
        end

        if @user.school_based_no_co_pay_full_day == true || @user.school_based_co_pay_full_day == true
          if location["program_information"].include?("CPS Based") && location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end 

        if @user.school_based_no_co_pay_half_day == true || @user.school_based_co_pay_half_day == true
          if location["program_information"].include?("CPS Based") || location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Part Day")
             @all_eligible_locations.push(location)
          end
        end

        if @user.head_start_center_based_half_day_3to5 == true 
          if location["program_information"].include?("Head Start") && location["program_information"].exclude?("CPS Based") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end

        if @user.early_head_start_childcare_collaboration == true 
          if location["program_information"].include?("Early Head Start") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end

        if @user.prevention_initiative_childcare_collaboration == true 
          if location["program_information"].include?("Community Based") && location["program_information"].exclude?("Head Start")&& location["program_information"].exclude?("Early Head Start") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end

        if @user.early_head_start_home_visiting_0to2 == true
          if location["program_information"].include?("Early Head Start") && location["program_information"].include?("Home Visiting") 
            @all_eligible_locations.push(location)
          end
        end

        if @user.head_start_home_visting_3to5 == true
          if location["program_information"].include?("Head Start") && location["program_information"].include?("Home Visiting")
            @all_eligible_locations.push(location)
          end 
        end

        if @user.head_start_school_based_half_day_3to5 == true
          if location["program_information"].include?("CPS Based") && location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Part Day")
            @all_eligible_locations.push(location)
          end
        end

        if @user.head_start_school_based_full_day_3to5 == true
          if location["program_information"].include?("CPS Based") && location["program_information"].include?("Head Start") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end
      end

      @eligible_locations = @all_eligible_locations.uniq


      # Filter by Zipcode
      @eligible_locations_in_zip = []
      @eligible_locations.each do |location|
        if @user.preferred_zipcode.present?
          if location["zip"].include?(@user.preferred_zipcode)
            @eligible_locations_in_zip.push(location)
          end
        else
          if location["zip"].include?(@user.zipcode)
            @eligible_locations_in_zip.push(location)
          end
        end
      end

      # If there are not 3 locations in zipcode
      if @eligible_locations_in_zip.length < 3
        if @user.preferred_zipcode.present?
          eligible_zipcode = ChicagoEligibleZipcode.find_by(zipcode: @user.preferred_zipcode)
        else
          eligible_zipcode = ChicagoEligibleZipcode.find_by(zipcode: @user.zipcode)
        end

        nearby_zipcodes = ChicagoEligibleZipcode.near([eligible_zipcode.latitude, eligible_zipcode.longitude], 10, :order => "distance")

        nearby_zipcodes.each do |nearby_zipcode|
          @eligible_locations.each_with_index do |location, index|
            if index == 0
            else
              if location["zip"].include?(nearby_zipcode.zipcode)
                @eligible_locations_in_zip.push(location)
              end
              break if @eligible_locations_in_zip.uniq.count >= 3
            end
          end
        end  
        @eligible_locations_in_zip = @eligible_locations_in_zip.uniq
      end

      puts " This is the eligible count #{@eligible_locations_in_zip.count}"


      if @eligible_locations_in_zip.length == 3
        @referral_centers = @eligible_locations_in_zip
      else
        # Filter by Day 
        @eligible_locations_in_zip_preferred_duration = []
        if @user.preferred_duration == "No Preference"
          @eligible_locations_in_zip_preferred_duration = @eligible_locations_in_zip
        else
          @eligible_locations_in_zip.each do |location|
            if @user.preferred_duration == "Half Day (2 or 3 hours)"
              if location["weekday_availability"].include?("Part Day")
                @eligible_locations_in_zip_preferred_duration.push(location)
              end
            elsif @user.preferred_duration == "Full Day (6 hours or more)"
              if location["weekday_availability"].include?("Full Day")
                @eligible_locations_in_zip_preferred_duration.push(location)
              end
            elsif @user.preferred_duration == "Home Visiting"
              if location["program_information"].include?("Home Visiting")
                @eligible_locations_in_zip_preferred_duration.push(location)
              end
            end
          end
        end

        if @eligible_locations_in_zip_preferred_duration.length == 3
          @referral_centers = @eligible_locations_in_zip_preferred_duration
        elsif @eligible_locations_in_zip_preferred_duration.length < 3
          # find locations nearby that are not in the preferred duration
          @referral_centers = @eligible_locations_in_zip_preferred_duration

          difference = 3 - @eligible_locations_in_zip_preferred_duration.length.to_i 
          non_duplicate_centers = @eligible_locations_in_zip - @eligible_locations_in_zip_preferred_duration
          random_additional_centers =  non_duplicate_centers.sample(difference)
         
          @referral_centers = @referral_centers + random_additional_centers
         
        else

          # Filter by language
          @eligible_locations_in_zip_preferred_duration_language = []

          if @user.bilingual_language == nil
            @eligible_locations_in_zip_preferred_duration_language = @eligible_locations_in_zip_preferred_duration
          else
            @eligible_locations_in_zip_preferred_duration.each do |location|
              if @user.bilingual_language == "Spanish"
                if location["languages_other_than_english"].present? && location["languages_other_than_english"].include?("Spanish")
                  @eligible_locations_in_zip_preferred_duration_language.push(location)
                end
              elsif @user.bilingual_language == "Mandarin"
                if location["languages_other_than_english"].present? 
                  if location["languages_other_than_english"].include?("Chinese") || location["languages_other_than_english"].include?("Cantonese") || location["languages_other_than_english"].include?("Cantinese")
                    @eligible_locations_in_zip_preferred_duration_language.push(location)
                  end
                end
              elsif @user.bilingual_language == "Yoruba"
                if location["languages_other_than_english"].present? && location["languages_other_than_english"].include?("Uraba")
                  @eligible_locations_in_zip_preferred_duration_language.push(location)
                end
              else
                if location["languages_other_than_english"].present? && location["languages_other_than_english"].include?(@user.bilingual_language)
                   @eligible_locations_in_zip_preferred_duration_language.push(location)
                end
              end
            end
          end

          if @eligible_locations_in_zip_preferred_duration_language.length == 3
            @referral_centers = @eligible_locations_in_zip_preferred_duration_language
          elsif @eligible_locations_in_zip_preferred_duration_language.length < 3
            # find locations nearby that are not in the preferred duration
            @referral_centers = @eligible_locations_in_zip_preferred_duration_language

            difference = 3 - @eligible_locations_in_zip_preferred_duration_language.length.to_i 
            non_duplicate_centers = @eligible_locations_in_zip_preferred_duration - @eligible_locations_in_zip_preferred_duration_language
            random_additional_centers =  non_duplicate_centers.sample(difference)

            @referral_centers = @referral_centers + random_additional_centers
            
          else

            # Filter by frequency
            @eligible_locations_in_zip_preferred_duration_language_frequency = []
            if @user.preferred_frequency == "No Preference"
              @eligible_locations_in_zip_preferred_duration_language_frequency = @eligible_locations_in_zip_preferred_duration_language
            else
              @eligible_locations_in_zip_preferred_duration_language.each do |location|
                if @user.preferred_frequency == "Part-week (2 to 3 days)"
                  if location["weekday_availability"].include?("Part Week")
                    @eligible_locations_in_zip_preferred_duration_language_frequency.push(location)
                  end
                elsif @user.preferred_frequency == "Full-week (4 to 5 days)"
                  if location["weekday_availability"].include?("Full Week")
                    @eligible_locations_in_zip_preferred_duration_language_frequency.push(location)
                  end
                end
              end
            end

            if @eligible_locations_in_zip_preferred_duration_language_frequency == 3
              @referral_centers = @eligible_locations_in_zip_preferred_duration_language_frequency
            elsif @eligible_locations_in_zip_preferred_duration_language_frequency.length < 3
              # find locations nearby that are not in the preferred duration
              @referral_centers = @eligible_locations_in_zip_preferred_duration_language_frequency
              
              difference = 3 - @eligible_locations_in_zip_preferred_duration_language_frequency.length.to_i 
              non_duplicate_centers = @eligible_locations_in_zip_preferred_duration_language - @eligible_locations_in_zip_preferred_duration_language_frequency
              random_additional_centers =  non_duplicate_centers.sample(difference)

              @referral_centers = referral_centers + random_additional_centers

            else
              @referral_centers = @eligible_locations_in_zip_preferred_duration_language_frequency
              
            end # end preferred frequency
          end # ends language
        end # ends the eligibile locations in zip with preferred duration if statement
      end # ends the eligible locations in zip if statement
    end # ends the eligible if statement

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


    if params[:employment].present? && params[:other_zipcode] && params[:preferred_duration]
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