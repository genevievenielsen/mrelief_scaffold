class AllCityProgramsController < ApplicationController
  before_action :set_all_city_program, only: [:show, :edit, :update, :destroy]
   skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /all_city_programs/new
  def new
    @all_city_program = AllCityProgram.new

    if params[:data].present? 
      @d = AllCityProgramDatum.new(JSON.parse(params[:data])) 
    else 
      @d = AllCityProgramDatum.new
    end

    if current_user.present?
      @current_user = current_user
    else
      @current_user = User.new
      if @current_user.save
        #session hash
        session[:user_id] = @current_user.id
      end
    end

    if params[:filtered_programs] == "false"
      @current_user.food_stamps = params[:food_stamps]
      @current_user.rta_ride_free = params[:rta_ride_free]
      @current_user.rental_assistance = params[:rental_assistance]
      @current_user.medicaid = params[:medicaid]
      @current_user.medicare_cost_sharing = params[:medicare_cost_sharing]
      @current_user.all_kids = params[:all_kids]
      @current_user.aabd = params[:aabd]
      @current_user.tanf = params[:tanf]
      @current_user.save
    end
  end

  # POST /all_city_programs
  # POST /all_city_programs.json
   def create
    @d = AllCityProgramDatum.new
    if current_user.present?
      @current_user = current_user
    else
      @current_user = User.last
    end

    if params[:dependent_no].present?
      # this is the words into numbers logic
      if params[:dependent_no] !~ /\D/  # returns true if all numbers
        dependent_no = params[:dependent_no].to_i
        @d.dependent_no = dependent_no
      else
        dependent_no = params[:dependent_no].in_numbers
        @d.dependent_no = dependent_no
      end
    end

    if params[:medicare_household_size].present?
      if params[:medicare_household_size] !~ /\D/
        medicare_household_size = params[:medicare_household_size].to_i
        @d.medicare_household_size = medicare_household_size
      else
        medicare_household_size = params[:medicare_household_size].in_numbers
        @d.medicare_household_size = medicare_household_size
      end
    end

    if params[:age].present?
      if params[:age] !~ /\D/
        @age = params[:age].to_i
        @d.age = @age
      else
        @age = params[:age].in_numbers
        @d.age = @age
      end
    end

    if params[:monthly_gross_income].present?
      monthly_gross_income = params[:monthly_gross_income]
      monthly_gross_income = monthly_gross_income.gsub(/[^0-9\.]/, '')
      if monthly_gross_income !~ /\D/
        monthly_gross_income = monthly_gross_income.to_i
        @d.monthly_gross_income = monthly_gross_income
      else
        if monthly_gross_income.include?("dollars")
          monthly_gross_income.slice!"dollars"
        end
        monthly_gross_income = monthly_gross_income.in_numbers
        @d.monthly_gross_income = monthly_gross_income
      end
    end

    if params[:net_income].present?
      net_income = params[:net_income]
      net_income = net_income.gsub(/[^0-9\.]/, '')
      if net_income !~ /\D/
        net_income = net_income.to_i
        @d.thirty_day_net_income = net_income
      else
        if net_income.include?("dollars")
          net_income.slice!"dollars"
        end
        net_income = net_income.in_numbers
        @d.thirty_day_net_income = net_income
      end
    end

    if params[:expect_child_support].present?
      expect_child_support = params[:expect_child_support]
      expect_child_support = expect_child_support.gsub(/[^0-9\.]/, '')
      if expect_child_support !~ /\D/
        expect_child_support = expect_child_support.to_i
        @d.child_support = expect_child_support
      else
        if expect_child_support.include?("dollars")
          expect_child_support.slice!"dollars"
        end
        expect_child_support = expect_child_support.in_numbers
        @d.child_support = expect_child_support
      end
    end

    if params[:expect_ssi].present?
      expect_ssi = params[:expect_ssi]
      expect_ssi = expect_ssi.gsub(/[^0-9\.]/, '')
      if expect_ssi !~ /\D/
        expect_ssi = expect_ssi.to_i
        @d.ssi = expect_ssi
      else
        if expect_ssi.include?("dollars")
          expect_ssi.slice!"dollars"
        end
        expect_ssi = expect_ssi.in_numbers
        @d.ssi = expect_ssi
      end
    end

    if params[:monthly_benefits].present?
      monthly_benefits = params[:monthly_benefits]
      monthly_benefits = monthly_benefits.gsub(/[^0-9\.]/, '')
      if monthly_benefits !~ /\D/
        monthly_benefits = monthly_benefits.to_i
        @d.monthly_benefits = monthly_benefits
      else
        if monthly_benefits.include?("dollars")
          monthly_benefits.slice!"dollars"
        end
        monthly_benefits = monthly_benefits.in_numbers
        @d.monthly_benefits = montly_benefits
      end
    end

    if params[:ninety_day_gross_income].present?
      ninety_day_gross_income = params[:ninety_day_gross_income]
      ninety_day_gross_income = ninety_day_gross_income.gsub(/[^0-9\.]/, '')
      if ninety_day_gross_income !~ /\D/
        ninety_day_gross_income = ninety_day_gross_income.to_i
        @d.ninety_day_gross_income = ninety_day_gross_income
      else
        if ninety_day_gross_income.include?("dollars")
          ninety_day_gross_income.slice!"dollars"
        end
        ninety_day_gross_income = ninety_day_gross_income.in_numbers
        @d.ninety_day_gross_income = ninety_day_gross_income
      end
    end

    if params[:annual_gross_income].present?
      annual_gross_income = params[:annual_gross_income]
      annual_gross_income = annual_gross_income.gsub(/[^0-9\.]/, '')
      if annual_gross_income !~ /\D/
        annual_gross_income = annual_gross_income.to_i
        @d.annual_gross_income = annual_gross_income
      else
        if annual_gross_income.include?("dollars")
          annual_gross_income.slice!"dollars"
        end
        annual_gross_income = annual_gross_income.in_numbers
        @d.annual_gross_income = annual_gross_income
      end
    end

    if params[:assets].present?
      assets = params[:assets]
      assets = assets.gsub(/[^0-9\.]/, '')
      if assets !~ /\D/
        assets = assets.to_i
        @d.assets = assets
      else
        if assets.include?("dollars")
          assets.slice!"dollars"
        end
        assets = assets.in_numbers
        @d.assets = assets
      end
    end

    if params[:children].present?
      if params[:children] !~ /\D/  # returns true if all numbers
        children = params[:children].to_i
        @d.number_of_children = children
      else
        children = params[:children].in_numbers
        @d.number_of_children = children
      end
    end

    # Data storage
      @d.user_location = params[:user_location]
      @d.enrolled_in_education = params[:education]
      @d.citizen = params[:citizen]
      @d.zipcode = params[:zipcode]
      @d.disabled_status = params[:disabled]
      @user_zipcode = params[:zipcode]

      if @d.user_location == 'king_community_service_center' || @d.user_location == 'garfield' || @d.user_location == 'north_area' || @d.user_location == 'englewood' || @d.user_location == 'south_chicago' || @d.user_location == 'trina_davila'
        @community_service_center = true
      else
        @community_service_center = false
      end

    #LOGIC FOR FOOD STAMPS
     if @current_user.food_stamps == "checked"
       @eligible_snap = "already receiving"
     else
        if params[:education]  == 'no' && params[:citizen] == 'yes'

            if @age <= 59
              snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => dependent_no })
            else
              snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => dependent_no})
            end

            if monthly_gross_income < snap_eligibility.snap_gross_income
              @eligible_snap = "yes"
            else
               @eligible_snap = "no"
            end

        elsif params[:education]  == 'yes'
          @eligible_snap = 'maybe'
        elsif params[:citizen] == 'no'
          @eligible_snap = 'maybe'
        end

      # this is the logic for disability
      if params[:disabled].present?
        if params[:disabled] != 'No'
          snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => dependent_no})
        else
          snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => dependent_no })
        end
            p "monthly_gross_income = #{monthly_gross_income}"
            p "snap_eligibility.snap_gross_income = #{snap_eligibility.snap_gross_income}"

            if monthly_gross_income < snap_eligibility.snap_gross_income
              @eligible_snap = "yes"
            else
               @eligible_snap = "no"
            end
            if params[:education]  == 'yes'
              @eligible_snap = 'maybe'
            elsif params[:citizen] == 'no'
              @eligible_snap = 'maybe'
            end
            if @age < 18
              @eligible_snap = "no"
            end
        end

      end

        zipcode = @user_zipcode << ".0"
        @lafcenter = LafCenter.find_by(:zipcode => zipcode)

        if @lafcenter.present?
        else
          @lafcenter = LafCenter.find_by(:center => "King Community Service Center")
          @laf_disclaimer = "We do not have an estimation of the nearest center that is in range for you at this time. But we recommend going to the center below."
        end

        #this is the logic for the community resources
        @user_zipcode = @user_zipcode.chomp(".0")
        @food_resources = ServiceCenter.where(:description => "food pantry")
        @food_resources_zip = @food_resources.where(:zip => @user_zipcode)

          #in this case there are 2 food pantries in the user's zip
          if @food_resources_zip.count >= 2
             @food_resources = @food_resources_zip
          end
          #in this case there is 1 food pantry in the user's zip
          if @food_resources_zip.count == 1
             @food_resources_first = @food_resources_zip.first
             @food_resources_second = @food_resources.first
          end
          #in this caser there are no food pantries in the user's zip
          if  @food_resources_zip.count == 0
              @food_resources_first = @food_resources.first
              @food_resources_second = @food_resources.second
          end


      #HERE IS THE LOGIC FOR RENTAL ASSISTANCE
      if @current_user.rental_assistance == "checked"
        puts "I made it here"
        @rental_eligible = "already receiving"
      else
       # Rental Status Variable
        @rental_status = ""
        if params[:medical].present?
          @medical_circumstance = "yes"
          @rental_status = @rental_status + "medical circumstance, " 
        end
        if params[:natural_disaster].present?
          @natural_disaster = "yes"
          @rental_status = @rental_status + "a victim of natural disaster or fire, "
        end
        if params[:eviction].present?
          @eviction = "yes"
          @rental_status = @rental_status + "a recipient of an eviction notice, "
        end
        if params[:income].present?
          @temporary_loss = "yes"
          @rental_status = @rental_status + "have experienced a temporary loss of income, "

        end
        if params[:domestic_violence] == "a victim of domestic violence"
          @domestic_violence = "yes"
          @rental_status =  @rental_status + "a victim of domestic violence, "
        end

      #Data Storage
        @d.name_on_lease = params[:lease]
        @d.next_month_rent = params[:next_rent]
        @d.rental_status = @rental_status

      #Logic
        rental_eligibility = RentalAssistance.find_by({ :rental_dependent_no => dependent_no })
        rental_cut_off =  rental_eligibility.rental_gross_income
        rental_cut_off_plus_200 = rental_eligibility.rental_gross_income + 200

          if params[:lease] == "no" || params[:next_rent] == "no"
            @rental_eligible = "no"

          elsif params[:lease] == "yes"
              if ninety_day_gross_income < rental_eligibility.rental_gross_income && params[:rental_status] != "none of the above"
                @rental_eligible = "yes"
              elsif ninety_day_gross_income < rental_cut_off_plus_200 && ninety_day_gross_income >= rental_cut_off && params[:rental_status] != "none of the above"
                @rental_eligible = "maybe"
              else
                @rental_eligible = "no"
              end
          end # closes the if statement about the lease agreement
      end

          housing = []
          ServiceCenter.all.each do |center|
            if center.description.match("housing")
              housing.push(center)
            end
          end

          @pb_zipcode = @user_zipcode.chomp(".0")
          @housing_resources = housing
          @housing_resources_zip = []

          housing.each do |center|
            if center.zip.match(@pb_zipcode)
              @housing_resources_zip.push(center)
            end
          end

          #in this case there are 2 housing centers in the user's zip
          if @housing_resources_zip.count >= 2
             @housing_resources = @housing_resources_zip
          end
          #in this case there is 1 aabd center in the user's zip
          if @housing_resources_zip.count == 1
             @housing_resources_first = @housing_resources_zip.first
             @housing_resources_second = @housing_resources.first
          end
          #in this caser there are no aabd centers in the user's zip
          if  @housing_resources_zip.count == 0
              @housing_resources_first = @housing_resources.first
              @housing_resources_second = @housing_resources.second
          end

      #HERE IS THE LOGIC FOR RTA RIDE FREE
      if @current_user.rta_ride_free == "checked"
        @eligible_rta = "already receiving"
      else
        rta_eligibility = RtaFreeRide.find_by({ :rta_dependent_no => dependent_no })
        if params[:disabled] != 'No' || @age > 65
         if annual_gross_income < rta_eligibility.rta_gross_income
          @eligible_rta = "yes"
         else
           @eligible_rta = "no"
         end
        else
          @eligible_rta = "no"
        end
      end

      transportation = []
      ServiceCenter.all.each do |center|
        if center.description.match("transportation")
          transportation.push(center)
        end
      end
      @pb_zipcode = @user_zipcode.chomp(".0")
        @transportation_resources = transportation
        @transportation_resources_zip = []

      transportation.each do |center|
        if center.zip.match(@pb_zipcode)
          @transportation_resources_zip.push(center)
        end
      end

      #in this case there are 2 medical centers in the user's zip
      if @transportation_resources_zip.count >= 2
         @transportation_resources = @transportation_resources_zip
      end
      #in this case there is 1 medical center in the user's zip
      if @transportation_resources_zip.count == 1
         @transportation_resources_first = @transportation_resources_zip.first
         @transportation_resources_second = @transportation_resources.first
      end
      #in this caser there are no medical centers in the user's zip
      if  @transportation_resources_zip.count == 0
          @transportation_resources_first = @transportation_resources.first
          @transportation_resources_second = @transportation_resources.second
      end

      #HERE IS THE LOGIC FOR MEDICAID
      if @current_user.medicaid == "checked"
        @eligible_medicaid = "already receiving"
      else
        medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => dependent_no})
        if params[:citizen] == 'no'
            @eligible_medicaid = 'maybe'
        elsif params[:citizen] == 'yes'
          if monthly_gross_income  < medicaid_eligibility.medicaid_gross_income
            @eligible_medicaid = 'yes'
          else
            @eligible_medicaid = 'no'
          end
        end
      end

      primarycare = []
      ServiceCenter.all.each do |center|
        if center.description.match("primary care")
          primarycare.push(center)
        end
      end

        @pb_zipcode = @user_zipcode.chomp(".0")
        @medical_resources = primarycare
        @medical_resources_zip = []

        primarycare.each do |center|
          if center.zip.match(@pb_zipcode)
            @medical_resources_zip.push(center)
          end
        end

       #in this case there are 2 medical centers in the user's zip
       if @medical_resources_zip.count >= 2
          @medical_resources = @medical_resources_zip
       end
       #in this case there is 1 medical center in the user's zip
       if @medical_resources_zip.count == 1
          @medical_resources_first = @medical_resources_zip.first
          @medical_resources_second = @medical_resources.first
       end
       #in this caser there are no medical centers in the user's zip
       if  @medical_resources_zip.count == 0
           @medical_resources_first = @medical_resources.first
           @medical_resources_second = @medical_resources.second
       end


      # HERE IS THE LOGIC FOR ALL KIDS
      # Health care status variable
      @healthcare_status = ""
      if params[:uninsured].present?
        @healthcare_status = @healthcare_status + "uninsured, " 
        puts @healthcare_status
      end
      if params[:job_ended].present?
        @healthcare_status = @healthcare_status + "job_ended, "
        puts @healthcare_status
      end
      if params[:cobra].present?
        @healthcare_status = @healthcare_status + "cobra, "
        puts @healthcare_status
      end
      if params[:status] == "none"
        @healthcare_status = @healthcare_status + "none"
        puts @healthcare_status
      end

      @d.pregnant = params[:pregnant]
      @d.child_health_insurance_state = @healthcare_status

      if @current_user.all_kids == "checked"
        @eligible_all_kids = "already receiving"
      else
        
      if children != 0 || params[:pregnant].present?
        if params[:pregnant].present?
           dependent_no_kids = children + 1
           dependent_no_kids = dependent_no_kids.to_i
           kids_eligibility = AllKid.find_by({ :kids_household_size => dependent_no_kids })
        else
          kids_eligibility = AllKid.find_by({ :kids_household_size => children })
        end

        if monthly_gross_income  < kids_eligibility.premium_1_gross_income
           @eligible_all_kids = "yes"
        else
          @eligible_all_kids = "no"
        end

         if @eligible_all_kids == "yes"
          # now find out which version they are eligible for
            if monthly_gross_income <= kids_eligibility.assist_gross_income
              @assist_eligible = "yes"
            elsif monthly_gross_income <= kids_eligibility.share_gross_income && monthly_gross_income > kids_eligibility.assist_gross_income
              @share_eligible = "yes"
            elsif monthly_gross_income <= kids_eligibility.premium_1_gross_income && monthly_gross_income > kids_eligibility.share_gross_income
              @premium1_eligible = "yes"
            end
         end

          #this is the logic for premium 2
          if monthly_gross_income <= kids_eligibility.premium_2_gross_income && monthly_gross_income > kids_eligibility.premium_1_gross_income
              if params["status"] == 'none'
                 @eligible_all_kids = "no"
              else
                @eligible_all_kids = "yes"
                @premium2_eligible = "yes"
              end
          end

          if monthly_gross_income > kids_eligibility.premium_2_gross_income
            @eligible_all_kids = "no"
          end
          if dependent_no == 1
            @eligible_all_kids = "no"
          end
          if params[:status] == "none"
            @eligible_all_kids = "no"
          end
        #no children
        else
          @eligible_all_kids = "no"
        end
      end

    #HERE IS THE LOGIC FOR MEDICARE COST SHARING
    if @current_user.medicare_cost_sharing == "checked"
      @eligible_medicare_cost_sharing = "already receiving"
    else
      if medicare_household_size == 0
        @eligible_medicare_cost_sharing = "no"

      elsif dependent_no == 1 && assets > 7280
        @eligible_medicare_cost_sharing = "no"

      elsif dependent_no > 1 && assets > 10930
        @eligible_medicare_cost_sharing = "no"

      else
        if medicare_household_size == 1
          monthly_gross_income = monthly_gross_income - 25
        elsif medicare_household_size == 2
          monthly_gross_income = monthly_gross_income - 50
        end

        medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => dependent_no })

        if monthly_gross_income < medicare_sharing_eligibility.premium_only
          @eligible_medicare_cost_sharing = "yes"

          if monthly_gross_income < medicare_sharing_eligibility.medicare_cost_sharing
            @eligible_p_d_c = "yes"

          elsif monthly_gross_income >= medicare_sharing_eligibility.medicare_cost_sharing
            @eligible_p = "yes"
          end
        end
       end
    end
    # end #this ends the present if statement

    # HERE IS THE LOGIC FOR AABD
    if @current_user.aabd == "checked"
      @aabd_eligible = "already receiving"
    else
      if params[:disabled] != 'No' || @age > 65
        if dependent_no  == 1
          if net_income + monthly_benefits < 821.38
            if assets < 2000
              @aabd_eligible = 'yes'
            else # exceed asset limit
              @aabd_eligible = 'no'
            end
          else # exceed income limit
            @aabd_eligible = "no"
          end
        elsif dependent_no  == 2
          if net_income + monthly_benefits < 724.38
            if assets < 3000
              @aabd_eligible = 'yes'
            else # exceed asset limit
              @aabd_eligible = 'no'
            end
          else # exceed income limit
            @aabd_eligible = "no"
          end
        else #household size is greater than 2
          if net_income + monthly_benefits < 724.38
            @aabd_eligible= 'maybe'
          else
            @aabd_eligible= 'no'
          end
        end

      else
        @aabd_eligible = 'no'
      end
      # if they are NOT receiving payment and are NOT over 65, not eligible

      if params[:citizen] == 'no'
        @aabd_eligible = 'maybe'
      end
    end

    aabd = []
    ServiceCenter.all.each do |center|
      if center.description.match("senior services")
        unless center.description.match("child care")
        aabd.push(center)
        end
      end
      if center.description.match("disabled")
        unless center.description.match("child care")
        aabd.push(center)
        end
      end
    end

    @pb_zipcode = @user_zipcode.chomp(".0")
      @aabd_resources = aabd
      @aabd_resources_zip = []
      aabd.each do |center|
        if center.zip.match(@pb_zipcode)
          @aabd_resources_zip.push(center)
        end
      end
      #in this case there are 2 aabd centers in the user's zip
      if @aabd_resources_zip.count >= 2
         @aabd_resources = @aabd_resources_zip
      end
      #in this case there is 1 aabd center in the user's zip
      if @aabd_resources_zip.count == 1
         @aabd_resources_first = @aabd_resources_zip.first
         @aabd_resources_second = @aabd_resources.first
      end
      #in this caser there are no aabd centers in the user's zip
      if  @aabd_resources_zip.count == 0
          @aabd_resources_first = @aabd_resources.first
          @aabd_resources_second = @aabd_resources.second
      end

      # HERE IS THE LOGIC FOR TANF
      # Pregnant or care for child
      @pregnant_or_caring_for_child = ""
      if params[:pregnant].present?
        @pregnant_or_caring_for_child = @pregnant_or_caring_for_child + "pregnant, " 
        puts @pregnant_or_caring_for_child
      end
      if params[:care_for_child].present?
        @pregnant_or_caring_for_child = @pregnant_or_caring_for_child + "care_for_child,  "
        puts @pregnant_or_caring_for_child
      end
      if params[:no_children].present?
        @pregnant_or_caring_for_child = @pregnant_or_caring_for_child + "no_children, "
        puts @pregnant_or_caring_for_child
      end

      @d.pregnant_or_caring_for_child = @pregnant_or_caring_for_child
      @d.relationship_to_child = params[:relationship]
      @d.pregnant_with_first_child = params[:first_child]
      @d.tanif_sixty_months = params[:tanif_sixty_months]
      @d.anticipate_other_income = params[:anticipate_income]
      @d.teen_parent = params[:teen_parent]
      @d.child_in_school = params[:no_highschool]

      if @current_user.tanf == "checked"
        @eligible_tanif  = "already receiving"
      else
        if params[:pregnant].present? || params[:care_for_child].present? || params[:first_child].present?
          if params[:relationship] == "adult relative"
            @eligible_tanif = "maybe"
          elsif params[:relationship] == "I do not care for a child" 
            @eligible_tanif = "no" unless params[:pregnant].present?
          else
            if params[:first_child] == "first_child"
              dependent_no == 1
            end
            if params[:tanif_sixty_months] == "yes"
               @eligible_tanif = "no"
            else
              if children < dependent_no - 1
                @eligible_tanif = "maybe"
              else
                tanif_eligibility = Tanif.find_by({ :household_size => dependent_no })
                reduced_gross_income = net_income * 0.75
                child_support = expect_child_support - 50
                total_income = reduced_gross_income + child_support
                if total_income > tanif_eligibility.max_income
                  @eligible_tanif = "no"
                else
                  if params[:anticipate_income] == "yes"
                    @eligible_tanif = "maybe"
                  else
                    if params[:teen_parent] == "teen_parent"
                      @eligible_tanif = "maybe"
                    else
                      if params[:citizen] == "no"
                        @eligible_tanif = "maybe"
                      else
                         if params[:highschool] == "no_highschool" && dependent_no == 2
                           @eligible_tanif = "no"
                         elsif params[:highschool] == "no_highschool" && dependent_no > 2
                           @eligible_tanif = "maybe"
                         else
                           @eligible_tanif = "yes"
                         end
                      end
                    end
                  end
                end
              end
            end
          end
        else
          @eligible_tanif = "no"
        end
        if params[:citizen] == "no"
          @eligible_tanif = "maybe"
        end
      end

      childcare = []
      ServiceCenter.all.each do |center|
        if center.description.match("child care")
          childcare.push(center)
        end
      end

      @pb_zipcode = @user_zipcode.chomp(".0")
        @child_resources = childcare
        @child_resources_zip = []

      childcare.each do |center|
        if center.zip.match(@pb_zipcode)
          @child_resources_zip.push(center)
        end
      end

      #in this case there are 2 medical centers in the user's zip
      if @child_resources_zip.count >= 2
         @child_resources = @child_resources_zip
      end

      #in this case there is 1 medical center in the user's zip
      if @child_resources_zip.count == 1
         @child_resources_first = @child_resources_zip.first
         @child_resources_second = @child_resources.first
      end

      #in this caser there are no medical centers in the user's zip
      if  @child_resources_zip.count == 0
          @child_resources_first = @child_resources.first
          @child_resources_second = @child_resources.second
      end


    @eligible_count = 0
    if  @eligible_snap == "yes"
      @eligible_count = @eligible_count + 1
      @d.snap_eligibility_status = "yes"
    end
    if @eligible_all_kids == "yes"
      @eligible_count = @eligible_count + 1
      @d.all_kids_eligibility_status = "yes"
    end
    if @eligible_rta == "yes"
      @eligible_count = @eligible_count + 1
      @d.rta_eligibility_status = "yes"
    end
    if @eligible_medicaid == "yes"
      @eligible_count = @eligible_count + 1
      @d.medicaid_eligibility_status = "yes"
    end
    if @eligible_medicare_cost_sharing == "yes"
      @eligible_count = @eligible_count + 1
      @d.medicare_cost_sharing_eligibility_status = "yes"
    end
    if @rental_eligible == "yes"
      @eligible_count = @eligible_count + 1
      @d.rental_eligibility_status = "yes"
    end
    if @aabd_eligible == "yes"
      @eligible_count = @eligible_count + 1
      @d.aabd_eligibility_status = "yes"
    end
    if @eligible_tanif == "yes"
      @eligible_count = @eligible_count + 1
      @d.tanf_eligibility_status = "yes"
    end


    @ineligible_count = 0
    if @eligible_snap == "no"
      @ineligible_count = @ineligible_count + 1
      @d.snap_eligibility_status = "no"
    end
    if @eligible_all_kids == "no"
      @ineligible_count = @ineligible_count + 1
      @d.all_kids_eligibility_status = "no"
    end
    if @eligible_rta == "no"
      @ineligible_count = @ineligible_count + 1
      @d.rta_eligibility_status = "no"
    end
    if @eligible_medicaid == "no"
      @ineligible_count = @ineligible_count + 1
      @d.medicaid_eligibility_status = "no"
    end
    if @eligible_medicare_cost_sharing == "no"
      @ineligible_count = @ineligible_count + 1
      @d.medicare_cost_sharing_eligibility_status = "no"
    end
    if @rental_eligible == "no"
      @ineligible_count = @ineligible_count + 1
      @d.rental_eligibility_status = "no"
    end
    if @aabd_eligible == "no"
      @ineligible_count = @ineligible_count + 1
      @d.aabd_eligibility_status = "no"
    end
    if @eligible_tanif == "no"
      @ineligible_count = @ineligible_count + 1
      @d.tanf_eligibility_status = "no"
    end


    @indeterminate_count = 0
    if  @eligible_snap == "maybe"
      @indeterminate_count = @indeterminate_count + 1
      @d.snap_eligibility_status = "maybe"
    end
    if @eligible_medicaid == 'maybe'
      @indeterminate_count = @indeterminate_count + 1
      @d.medicaid_eligibility_status = "maybe"
    end
    if @rental_eligible == "maybe"
      @indeterminate_count = @indeterminate_count + 1
      @d.rental_eligibility_status = "maybe"
    end
    if @aabd_eligible == 'maybe'
      @indeterminate_count = @indeterminate_count + 1
      @d.aabd_eligibility_status = "maybe"
    end
    if @eligible_tanif == 'maybe'
      @indeterminate_count = @indeterminate_count + 1
      @d.tanf_eligibility_status = "maybe"
    end

    @already_receiving_count = 0
    if @eligible_snap == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.snap_eligibility_status = "already receiving"
    end
    if @eligible_all_kids == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.all_kids_eligibility_status = "already receiving"
    end
    if @eligible_rta == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.rta_eligibility_status = "already receiving"
    end
    if @eligible_medicaid == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.medicaid_eligibility_status = "already receiving"
    end
    if @eligible_medicare_cost_sharing == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.medicare_cost_sharing_eligibility_status = "already receiving"
    end
    if @rental_eligible == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.rental_eligibility_status = "already receiving"
    end
    if @aabd_eligible == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.aabd_eligibility_status = "already receiving"
    end
    if @eligible_tanif == "already receiving"
      @already_receiving_count = @already_receiving_count + 1
      @d.tanf_eligibility_status = "already receiving"
    end

    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.zipcode = @user_zipcode
    @d.save
    @d_json = @d.attributes.to_json

    # if params[:citizen].present? && params[:disabled].present? && params[:education].present? && params[:anticipate_income].present?
    # else
    #    flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
    #   render "new"
    # end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_all_city_program
      @all_city_program = AllCityProgram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def all_city_program_params
      params[:all_city_program]
    end
end
