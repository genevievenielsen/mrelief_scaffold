class WicsController < ApplicationController
  before_action :set_wic, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /wics/new
  def new
    @wic = Wic.new
  end

  def create
    w = WicData.new
    if params[:wic_household_size] !~ /\D/  # returns true if all numbers
      wic_household_size = params[:wic_household_size].to_i
      w.household_size = wic_household_size
    else
      wic_household_size = params[:wic_household_size].in_numbers
      w.household_size = wic_household_size
    end

    wic_gross_income = params[:wic_gross_income]
    wic_gross_income = wic_gross_income.gsub(/[^0-9\.]/, '')

    if wic_gross_income !~ /\D/
      wic_gross_income = wic_gross_income.to_i
      w.gross_monthly_income = wic_gross_income
    else
      if wic_gross_income.include?("dollars")
        wic_gross_income.slice!"dollars"
      end
      wic_gross_income = wic_gross_income.in_numbers
      w.gross_monthly_income = wic_gross_income
    end


    wic_status = params[:wic_status]
    w.health_status = params[:wic_status]

    if  wic_gross_income.present? && wic_household_size.present?

      wic_eligibility = Wic.find_by({ :wic_household_size => wic_household_size })

      if wic_gross_income < wic_eligibility.wic_gross_income
        if wic_status != 'none of the above'
          @eligible = true
          w.eligibility_status = "yes"
        else
          w.eligibility_status = "no"
        end
      end

    else
       redirect_to :back, :notice => "All fields are required."
    end

  @user_zipcode = params[:zipcode]
  @zipcode = @user_zipcode << ".0"
  @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

  if @lafcenter.present?
  else
    @lafcenter = LafCenter.find_by(:id => 10)
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

    w.user_location = params[:user_location]
    w.phone_number = params[:phone_number] if params[:phone_number].present?
    w.zipcode = params[:zipcode]
    w.save

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
