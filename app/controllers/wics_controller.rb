class WicsController < ApplicationController
  before_action :set_wic, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /wics/new
  def new
    @wic = Wic.new
    if params[:data].present? 
      @d = WicData.new(JSON.parse(params[:data])) 
    else 
      @d = WicData.new
    end
    @current_user = current_user
  end

  def create
    @d = WicData.new
    if params[:wic_household_size] !~ /\D/  # returns true if all numbers
      wic_household_size = params[:wic_household_size].to_i
      @d.household_size = wic_household_size
    else
      wic_household_size = params[:wic_household_size].in_numbers
      @d.household_size = wic_household_size
    end


    if params[:wic_gross_income] !~ /\D/
      wic_gross_income = wic_gross_income.to_i
      @d.gross_monthly_income = wic_gross_income
    else
      if wic_gross_income.include?("dollars")
        wic_gross_income.slice!"dollars"
      end
      wic_gross_income = wic_gross_income.in_numbers
      @d.gross_monthly_income = wic_gross_income
    end


    @d.health_status = params[:wic_status]
    @d.health_status = params[:wic_status]
    @d.pregnant_or_child = params[:pregnant_or_child]
    @d.snap_tanf_medicaid = params[:snap_tanf_medicaid]

    if @d.health_status == "yes"

      if @d.pregnant_or_child == "yes"
        if @d.snap_tanf_medicaid == "yes"
          @eligible = true
        else
          income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => wic_household_size})
          if @d.household_size < income_row.income_type2
            @eligible = true
          else
            @eligible = false
          end
        end
      else
      # no children
        @eligible = false
      end
    else
      # ineligible wic status
      @eligible = false
    end

    if @eligible == false
      @d.eligibility_status = "no"
    else
      @d.eligibility_status = "yes"
    end


  @user_zipcode = params[:zipcode]
  @zipcode = @user_zipcode << ".0"
  @wic_location = WicLocation.find_by(:zipcode => @zipcode)

  if @wic_location.present?
  else
    @wic_location = WicLocation.first
  end

  childcare = []
  ServiceCenter.all.each do |center|
    if center.description.match("child care")
      childcare.push(center)
    end
  end


    @pb_zipcode = @user_zipcode.chomp(".0")
    @resources = childcare
    @resources_zip = []

    childcare.each do |center|
      if center.zip.match(@pb_zipcode)
        @resources_zip.push(center)
      end
    end

    #in this case there are 2 medical centers in the user's zip
    if @resources_zip.count >= 2
       @resources = @resources_zip
    end
    #in this case there is 1 medical center in the user's zip
    if @resources_zip.count == 1
       @resources_first = @resources_zip.first
       @resources_second = @resources.first
    end
    #in this caser there are no medical centers in the user's zip
    if  @resources_zip.count == 0
        @resources_first = @resources.first
        @resources_second = @resources.second
    end

    @d.user_location = params[:user_location]
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.zipcode = @user_zipcode.chop.chop
    @d.save

    @d_json = @d.attributes.to_json


    if params[:wic_status].present?
    else
       flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
      render "new"
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wic
      @wic = Wic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wic_params
      params.require(:wic).permit(:wic_household_size, :wic_gross_income)
    end
end
