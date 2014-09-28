class AllCityProgramsController < ApplicationController
  before_action :set_all_city_program, only: [:show, :edit, :update, :destroy]



  # GET /all_city_programs/new
  def new
    @all_city_program = AllCityProgram.new
  end


  # POST /all_city_programs
  # POST /all_city_programs.json
  def create
    @all_city_program = AllCityProgram.new#(all_city_program_params)

    if params[:dependent_no] !~ /\D/  # returns true if all numbers
      dependent_no = params[:dependent_no].to_i
    else
      dependent_no = params[:dependent_no].in_numbers
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

      rental_eligibility = RentalAssistance.find_by({ :rental_dependent_no => dependent_no })

       p "ninety_day_gross_income = #{ninety_day_gross_income}"
       p "rental_eligibility.rental_gross_income = #{rental_eligibility.rental_gross_income}"

       if ninety_day_gross_income < rental_eligibility.rental_gross_income && params[:rental_status] != "none of the above" && params[:citizen] == 'yes'
          @eligible_rental = "yes"
        else
          @eligible_rental = "no"
       end


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


    end #this ends the present if statement

    respond_to do |format|
      if @all_city_program.save
        format.html { redirect_to @all_city_program, notice: 'All city program was successfully created.' }
        format.json { render :show, status: :created, location: @all_city_program }
      else
        format.html { render :new }
        format.json { render json: @all_city_program.errors, status: :unprocessable_entity }
      end
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
