  class EarlyLearningProgramsController < ApplicationController
  require 'open-uri'
  require 'json'  

	def new
		@user = EarlyLearningData.new
	end

	def create
    @user = EarlyLearningData.new
    # DATA STORAGE
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

    # categorical select all
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
    if params[:teen_parent].present?
      @user.teen_parent = true
    end
    if params[:special_needs].present?
      @user.special_needs = true
    end
    if params[:none_of_the_above].present?
      @user.none_of_the_above = true
    end

    # homeless select all
    if params[:homeless_fixed_residence].present?
      @user.homeless_fixed_residence = true
    end 
    if params[:homeless_hotels].present?
      @user.homeless_hotels = true
    end 
    if params[:homeless_shelters].present?
      @user.homeless_shelters = true
    end 
    if params[:not_homeless].present?
      @user.not_homeless = true
    end

    if @user.homeless_fixed_residence == true || @user.homeless_hotels == true || @user.homeless_shelters == true
      @homeless = true
    end

    # duration preference select all
    if params[:half_day].present?
      @user.half_day = true
    end 
    if params[:full_day].present?
      @user.full_day = true
    end 
    if params[:part_week].present?
      @user.part_week = true
    end 
    if params[:full_week].present?
      @user.full_week = true
    end 
    if params[:home_visiting].present?
      @user.home_visiting = true
    end
    if params[:no_duration_preference].present?
      @user.no_duration_preference = true
    end

    # yes or no questions
    if params[:employment] == "yes" || params[:employment] == "sí"
      @user.employed = "yes"
    elsif params[:employment] == "no" 
      @user.employed = "no"
    end

    if params[:other_zipcode] == "yes" || params[:other_zipcode] == "sí"
      @user.other_zipcode = "yes"
    elsif params[:other_zipcode] == "no" 
      @user.other_zipcode = "no"
    end

    if params[:bilingual] == "yes" || params[:bilingual] == "sí"
      @user.bilingual = "yes"
    elsif params[:bilingual] == "no" 
      @user.bilingual = "no"
    end

    @user.preferred_zipcode = params[:preferred_zipcode]
    @user.bilingual_language = params[:bilingual_language]

    @user.zipcode = params[:zipcode]
    @user.phone_number = params[:phone_number] if params[:phone_number].present?
    @user.save

    # @d_json = @user.attributes.to_json

    # spanish translation 
    if I18n.locale == :es
      @user.spanish = true
    end

    # ELIGIBILITY DETERMINATION
    if @user.no_children == true 
      # user has no children
      @eligible = false
    else
      if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false
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
                if @user.foster_parent == true || @homeless == true || @user.ssi == true || @user.tanf == true
        
                  if @user.foster_parent == true || @homeless == true
                    additional_criteria = ["foster care, homeless, ssi or tanf", "foster care or homeless"]
                    @eligible_early_learning_programs = correct_age_programs.where(additional_criteria: additional_criteria)
                  else
                    @eligible_early_learning_programs = correct_age_programs.where(additional_criteria: "foster care, homeless, ssi or tanf")
                  end
              
                else
                # User is not automatically income eligible 
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

                    if @eligible_early_learning_programs.length == 0
                      @no_programs_available = true
                    end
                    puts "MADE IT TO ELIGIBLE PROGRAMS "
                    
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
      end # end user only has a 6 to 12 year old
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
      # @user.save
    end

    # LOOK CENTERS IN DATA PORTAL
    if @eligible == false || @no_programs_available == true
    else
      url = "https://data.cityofchicago.org/resource/ck29-hb9r.json"
      raw_data = open(url).read
      parsed_data = JSON.parse(raw_data)
      @all_eligible_locations = []

      # Filter by Eligibility
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
          if location["program_information"].include?("CPS Based") && location["program_information"].include?("CPS Based, Head Start") && location["weekday_availability"].include?("Full Day")
            @all_eligible_locations.push(location)
          end
        end 
        if @user.school_based_no_co_pay_half_day == true || @user.school_based_co_pay_half_day == true
          if location["program_information"].include?("CPS Based") || location["program_information"].include?("CPS Based, Head Start") && location["weekday_availability"].include?("Part Day")
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

      # Filter by Age
      @eligible_locations_ages = []
      @eligible_locations.each do |location|
        if @user.three_and_under == true && @user.three_to_five == true
          if location["ages_0_3"] == true && location["ages_3_5"] == true
            @eligible_locations_ages.push(location)
          end
        elsif @user.pregnant == true && @user.three_to_five == true
          if location["ages_0_3"] == true && location["ages_3_5"] == true
            @eligible_locations_ages.push(location)
          end
        elsif @user.three_and_under == true || @user.pregnant == true
          if location["ages_0_3"] == true
            @eligible_locations_ages.push(location)
          end
        elsif @user.three_to_five == true
          if location["ages_3_5"] == true
            @eligible_locations_ages.push(location)
          end
        end
      end

        # If a parent has children between 0 and 5 and there are no matches, find matches for the 3 to 5 group
        if @user.three_and_under == true && @user.three_to_five == true && @eligible_locations_ages.length == 0
          @eligible_locations.each do |location|
            if location["ages_3_5"] == true
              @eligible_locations_ages.push(location)
            end
          end
        elsif @user.pregnant == true && @user.three_to_five == true && @eligible_locations_ages.length == 0
          @eligible_locations.each do |location|
            if location["ages_3_5"] == true
              @eligible_locations_ages.push(location)
            end
          end
        end

      # Filter by Length of Day 
      @eligible_locations_ages_day = []
      @eligible_locations_ages.each do |location|
        if @user.no_duration_preference == true 
          @eligible_locations_ages_day = @eligible_locations_ages
        elsif @user.full_day == true
          if location["weekday_availability"].include?("Full Day")
            @eligible_locations_ages_day.push(location)
          end
        elsif @user.half_day == true
          if location["weekday_availability"].include?("Part Day")
            @eligible_locations_ages_day.push(location)
          end
        elsif @user.home_visiting == true
          if location["program_information"].include?("Home Visiting")
            @eligible_locations_ages_day.push(location)
          end
        else
          @eligible_locations_ages_day = @eligible_locations_ages
        end    
      end

      # Filter by Zipcode
      @eligible_locations_ages_day_zip = []
      @eligible_locations_ages_day.each do |location|
        if @user.preferred_zipcode.present?
          if location["zip"].include?(@user.preferred_zipcode)
            @eligible_locations_ages_day_zip.push(location)
          end
        else
          if location["zip"].include?(@user.zipcode)
            @eligible_locations_ages_day_zip.push(location)
          end
        end
      end

      # Filter by nearby zipcodes if there are not 3 locations in zipcode
      if @eligible_locations_ages_day_zip.length < 3
        if @user.preferred_zipcode.present?
          eligible_zipcode = ChicagoEligibleZipcode.find_by(zipcode: @user.preferred_zipcode)
        else
          eligible_zipcode = ChicagoEligibleZipcode.find_by(zipcode: @user.zipcode)
        end
        nearby_zipcodes = ChicagoEligibleZipcode.near([eligible_zipcode.latitude, eligible_zipcode.longitude], 10, :order => "distance")
        nearby_zipcodes.each do |nearby_zipcode|
          @eligible_locations_ages_day.each_with_index do |location, index|
            if index == 0
            else
              if location["zip"].include?(nearby_zipcode.zipcode)
                @eligible_locations_ages_day_zip.push(location)
              end
              break if @eligible_locations_ages_day_zip.uniq.count >= 3
            end
          end
        end  
        @eligible_locations_ages_day_zip = @eligible_locations_ages_day_zip.uniq
      end

      if @eligible_locations_ages_day_zip.length == 3
        @referral_centers = @eligible_locations_ages_day_zip
      else
        # Filter by language
        @eligible_locations_ages_day_zip_language = []
          if @user.bilingual_language == nil
            @eligible_locations_ages_day_zip_language = @eligible_locations_ages_day_zip
          else
            @eligible_locations_ages_day_zip.each do |location|
              if @user.bilingual_language == "Spanish"
                if location["languages_other_than_english"].present? && location["languages_other_than_english"].include?("Spanish")
                  @eligible_locations_ages_day_zip_language.push(location)
                end
              elsif @user.bilingual_language == "Mandarin"
                if location["languages_other_than_english"].present? 
                  if location["languages_other_than_english"].include?("Chinese") || location["languages_other_than_english"].include?("Cantonese") || location["languages_other_than_english"].include?("Cantinese")
                    @eligible_locations_ages_day_zip_language.push(location)
                  end
                end
              elsif @user.bilingual_language == "Yoruba"
                if location["languages_other_than_english"].present? && location["languages_other_than_english"].include?("Uraba")
                  @eligible_locations_ages_day_zip_language.push(location)
                end
              else
                if location["languages_other_than_english"].present? && location["languages_other_than_english"].include?(@user.bilingual_language)
                   @eligible_locations_ages_day_zip_language.push(location)
                end
              end
            end
          end

          if @eligible_locations_ages_day_zip_language.length == 3
            @referral_centers = @eligible_locations_ages_day_zip_language
          elsif @eligible_locations_ages_day_zip_language.length < 3
            # find locations nearby that are not in the preferred duration
            @referral_centers = @eligible_locations_ages_day_zip_language

            difference = 3 - @eligible_locations_ages_day_zip_language.length.to_i 
            non_duplicate_centers = @eligible_locations_ages_day_zip - @eligible_locations_ages_day_zip_language
            random_additional_centers =  non_duplicate_centers.sample(difference)

            @referral_centers = @referral_centers + random_additional_centers

          else

            # Filter by Quality
            @eligible_locations_ages_day_zip_language_quality = []
              gold_locations = []
              silver_locations = [] 
              bronze_locations = []

              @eligible_locations_ages_day_zip_language.each do |location|
                if location["quality_rating"].present? && location["quality_rating"] == "Gold"
                  gold_locations.push(location)
                end
                if location["quality_rating"].present? && location["quality_rating"] == "Silver"
                  silver_locations.push(location)
                end
                if location["quality_rating"].present? && location["quality_rating"] == "Bronze"
                  bronze_locations.push(location)
                end
              end

              if gold_locations.length > 0
                @eligible_locations_ages_day_zip_language_quality = @eligible_locations_ages_day_zip_language_quality + gold_locations
              end

              if @eligible_locations_ages_day_zip_language_quality.length < 3 && silver_locations.length > 0
                @eligible_locations_ages_day_zip_language_quality = @eligible_locations_ages_day_zip_language_quality + silver_locations
              end

              if @eligible_locations_ages_day_zip_language_quality.length < 3 && bronze_locations.length > 0
                @eligible_locations_ages_day_zip_language_quality = @eligible_locations_ages_day_zip_language_quality + bronze_locations
              end

              if @eligible_locations_ages_day_zip_language_quality.length < 3 
                # find locations nearby that are licensed
                @referral_centers = @eligible_locations_ages_day_zip_language_quality

                difference = 3 - @eligible_locations_ages_day_zip_language_quality.length.to_i 
                non_duplicate_centers = @eligible_locations_ages_day_zip_language - @eligible_locations_ages_day_zip_language_quality
                random_additional_centers =  non_duplicate_centers.sample(difference)

                @referral_centers = @referral_centers + random_additional_centers
          
              else
                # Filter by Length of Week
                @eligible_locations_ages_day_zip_language_quality_week = []
                if @eligible_locations_ages_day_zip_language_quality.length == 3
                  @eligible_locations_ages_day_zip_language_quality_week == @eligible_locations_ages_day_zip_language_quality
                else
                  
                  if @user.no_duration_preference == true
                    @eligible_locations_ages_day_zip_language_quality_week = @eligible_locations_ages_day_zip_language_quality
                  else
                    @eligible_locations_ages_day_zip_language_quality.each do |location|
                      if @user.part_week == true
                        if location["weekday_availability"].include?("Part Week")
                          @eligible_locations_ages_day_zip_language_quality_week.push(location)
                        end
                      elsif @user.full_week == true
                        if location["weekday_availability"].include?("Full Week")
                          @eligible_locations_ages_day_zip_language_quality_week.push(location)
                        end
                      end
                    end
                  end
                end

                if @eligible_locations_ages_day_zip_language_quality_week.length == 3
                  @referral_centers = @eligible_locations_ages_day_zip_language_quality_week

                elsif @eligible_locations_ages_day_zip_language_quality_week.length < 3
                  # find locations nearby that are not in the preferred duration
                  @referral_centers = @eligible_locations_ages_day_zip_language_quality_week
                  
                  difference = 3 - @eligible_locations_ages_day_zip_language_quality_week.length.to_i 
                  non_duplicate_centers = @eligible_locations_ages_day_zip_language_quality - @eligible_locations_ages_day_zip_language_quality_week
                  random_additional_centers =  non_duplicate_centers.sample(difference)

                  @referral_centers = @referral_centers + random_additional_centers

                else
                  @referral_centers = @eligible_locations_ages_day_zip_language_quality_week
                end

              end
          end # ends the quality if statement 
      end # ends the language if statement

       if @referral_centers.length > 3 
         @top_referrals = @referral_centers.sample(3) 
       else 
         @top_referrals = @referral_centers 
       end 

       @user.referral_key1 = @top_referrals.first["key"]
       @user.referral_key2 = @top_referrals.second["key"]
       @user.referral_key3 = @top_referrals.third["key"]
       # @user.save
   
    end # ends the eligible if statement

    # CCAP ELIGIBILITY
      if @user.three_and_under == true || @user.pregnant == true || @user.three_to_five == true || @user.six_to_twelve == true
        if @user.tanf == true || @user.teen_parent == true || @user.special_needs == true
          @ccap_eligible = true
          
        elsif @user.employed == "yes" 
          income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})
          if @user.gross_monthly_income < income_row.income_type4
            @ccap_eligible = true
          else
             @ccap_eligible = false
          end
        else
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
    # @user.save 

    if params[:half_day].present? && params[:full_day].present? 
      if I18n.locale == :es
        flash.now[:alert] = "“Medio día” y “día completo” no se pueden seleccionar juntos. Por favor seleccione una de las dos opciones."
      else
        flash.now[:alert] = "Half Day and Full Day cannot be selected together. Please choose one of these two options."
      end
      render 'new'
      return
    end

    if params[:part_week].present? && params[:full_week].present? 
      if I18n.locale == :es
        flash.now[:alert] = "No se puede escoger ‘Semana parcial’ y ‘Semana completa’. Por favor escoja una de estas dos opciones."
      else
        flash.now[:alert] = "Part Week and Full Week cannot be selected together. Please choose one of these two options."
      end
      render 'new'
      return
    end

    if params[:employment].present? && params[:other_zipcode].present? && params[:bilingual].present?
      # age questions
      if params[:zero_to_three].present? || params[:three_to_five].present? || params[:six_to_twelve].present? || params[:pregnant].present? || params[:no_children].present?
        # categorical eligibility questions
        if params[:foster_parent].present? || params[:homeless].present? || params[:ssi].present? || params[:tanf].present? || params[:teen_parent].present? || params[:special_needs].present? || params[:none_of_the_above].present?
          # homeless questions
          if params[:homeless_fixed_residence].present? || params[:homeless_hotels].present? || params[:homeless_shelters].present? || params[:not_homeless].present?
            # preferred duration questions
            if params[:half_day].present? || params[:full_day].present? || params[:part_week].present? || params[:full_week].present? || params[:home_visiting].present? || params[:no_duration_preference].present?
              @user.complete = true
            else
              forgot_question_message
            end
          else
            forgot_question_message
          end
        else
          forgot_question_message
        end
      else
        forgot_question_message
      end
    else
      forgot_question_message
    end

    @user.save       
	end # closes the method

  def forgot_question_message
    if I18n.locale == :es
      flash.now[:alert] = "¡Parece que usted olvidó contestar una pregunta! Por favor conteste todas las preguntas a continuación."
    else
      flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
    end
    render "new"
  end


  def more_results
    @user = EarlyLearningData.find(params[:id])
  end
end # closes the class