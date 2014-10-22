class AllCityProgramsController < ApplicationController
  before_action :set_all_city_program, only: [:show, :edit, :update, :destroy]
   skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token



  # GET /all_city_programs/new
  def new
    @all_city_program = AllCityProgram.new
  end


  # POST /all_city_programs
  # POST /all_city_programs.json
   def create
    # this is the words into numbers logic
    if params[:dependent_no] !~ /\D/  # returns true if all numbers
      dependent_no = params[:dependent_no].to_i
    else
      dependent_no = params[:dependent_no].in_numbers
    end

    if params[:medicare_household_size] !~ /\D/
      medicare_household_size = params[:medicare_household_size].to_i
    else
      medicare_household_size = params[:medicare_household_size].in_numbers
    end

    if params[:age] !~ /\D/
      age = params[:age].to_i
    else
      age = params[:age].in_numbers
    end

    monthly_gross_income = params[:monthly_gross_income]
    monthly_gross_income = monthly_gross_income.gsub(/[^0-9\.]/, '')

    if monthly_gross_income !~ /\D/
      monthly_gross_income = monthly_gross_income.to_i
    else
      if monthly_gross_income.include?("dollars")
        monthly_gross_income.slice!"dollars"
      end
      monthly_gross_income = monthly_gross_income.in_numbers
    end

    ninety_day_gross_income = params[:ninety_day_gross_income]
    ninety_day_gross_income = ninety_day_gross_income.gsub(/[^0-9\.]/, '')

    if ninety_day_gross_income !~ /\D/
      ninety_day_gross_income = ninety_day_gross_income.to_i
    else
      if ninety_day_gross_income.include?("dollars")
        ninety_day_gross_income.slice!"dollars"
      end
      ninety_day_gross_income = ninety_day_gross_income.in_numbers
    end

    annual_gross_income = params[:annual_gross_income]
    annual_gross_income = annual_gross_income.gsub(/[^0-9\.]/, '')

    if annual_gross_income !~ /\D/
      annual_gross_income = annual_gross_income.to_i
    else
      if annual_gross_income.include?("dollars")
        annual_gross_income.slice!"dollars"
      end
      annual_gross_income = annual_gross_income.in_numbers
    end

    assets = params[:assets]
    assets = assets.gsub(/[^0-9\.]/, '')

    if assets !~ /\D/
      assets = assets.to_i
    else
      if assets.include?("dollars")
        assets.slice!"dollars"
      end
      assets = assets.in_numbers
    end



     if age.present? && monthly_gross_income.present? && ninety_day_gross_income.present? &&
      annual_gross_income.present?

     # this is the logic for snap

        if params[:education]  == 'no' && params[:citizen] == 'yes'

            if age <= 59
              snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => dependent_no })
            else
              snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => dependent_no})
            end

            p "monthly_gross_income = #{monthly_gross_income}"
            p "snap_eligibility.snap_gross_income = #{snap_eligibility.snap_gross_income}"

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


      @user_zipcode = params[:zipcode]
      zipcode = @user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => zipcode)

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

      # this is the logic for disability
      if params[:disabled].present?

        if params[:disabled] != 'none'
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
        end



      #here is the logic for rental assistance

      # rental_eligibility = RentalAssistance.find_by({ :rental_dependent_no => dependent_no })

      #  p "ninety_day_gross_income = #{ninety_day_gross_income}"
      #  p "rental_eligibility.rental_gross_income = #{rental_eligibility.rental_gross_income}"

      #  if ninety_day_gross_income < rental_eligibility.rental_gross_income && params[:rental_status] != "none of the above" && params[:citizen] == 'yes'
      #     @eligible_rental = "yes"
      #   else
      #     @eligible_rental = "no"
      #  end


        #here is the logic for rta ride free
       rta_eligibility = RtaFreeRide.find_by({ :rta_dependent_no => dependent_no })

       if age < 65
        @eligible_rta = "no"

       else

        p "annual_gross_income = #{annual_gross_income}"
        p "rta_eligibility.annual_gross_income = #{rta_eligibility.rta_gross_income}"

        if annual_gross_income < rta_eligibility.rta_gross_income
          @eligible_rta = "yes"
        else
          @eligible_rta = "no"
        end
      end

      #here is the logic for medicaid

      medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => dependent_no})

      if params[:citizen] == 'no'
          @eligible_medicaid = 'maybe'
      elsif params[:citizen] == 'yes'
        if annual_gross_income < medicaid_eligibility.medicaid_gross_income
          @eligible_medicaid = 'yes'
        else
          @eligible_medicaid = 'no'
        end
    end


      #here is the logic for all kids
      if params[:pregnant].present?
        if params[:pregnant] == 'yes'
          dependent_no = dependent_no + 1
        end
      end
      kids_eligibility = AllKid.find_by({ :kids_household_size => dependent_no })

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

        if params[:status] == "no_children"
          @eligible_all_kids = "no"
        end


    #this is the logic for medicare cost sharing
    if medicare_household_size == 0
      @eligible_medicare_cost_sharing = "no"

    elsif dependent_no == 1 && assets > 7160
      @eligible_medicare_cost_sharing = "no"

    elsif dependent_no > 1 && assets > 10750
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

    end #this ends the present if statement

    @eligible_count = 0
    if  @eligible_snap == "yes"
      @eligible_count = @eligible_count + 1
    end

    if @eligible_all_kids == "yes"
      @eligible_count = @eligible_count + 1
    end

    if @eligible_rta == 'yes'
      @eligible_count = @eligible_count + 1
    end
    if @eligible_medicaid == 'yes'
      @eligible_count = @eligible_count + 1
    end
    if @eligible_medicare_cost_sharing == 'yes'
      @eligible_count = @eligible_count + 1
    end


    @ineligible_count = 0
    if  @eligible_snap == "no"
      @ineligible_count = @ineligible_count + 1
    end

    if @eligible_all_kids == "no"
      @ineligible_count = @ineligible_count + 1
    end

    if @eligible_rta == 'no'
      @ineligible_count = @ineligible_count + 1
    end
    if @eligible_medicaid == 'no'
      @ineligible_count = @ineligible_count + 1
    end
    if @eligible_medicare_cost_sharing == 'no'
      @ineligible_count = @ineligible_count + 1
    end


    @indeterminate_count = 0
    if  @eligible_snap == "maybe"
      @indeterminate_count = @indeterminate_count + 1
    end


    if @eligible_medicaid == 'maybe'
      @indeterminate_count = @indeterminate_count + 1
    end


  end



  # DELETE /all_city_programs/1
  # DELETE /all_city_programs/1.json
  def destroy
    @all_city_program.destroy
    respond_to do |format|
      format.html { redirect_to all_city_programs_url, notice: 'All city program was successfully destroyed.' }
      format.json { head :no_content }
    end
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
