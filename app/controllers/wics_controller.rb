class WicsController < ApplicationController
  before_action :set_wic, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token



  # GET /wics/new
  def new
    @wic = Wic.new
  end

  def create

    if params[:wic_household_size] !~ /\D/  # returns true if all numbers
      wic_household_size = params[:wic_household_size].to_i
    else
      wic_household_size = params[:wic_household_size].in_numbers
    end


    wic_gross_income = params[:wic_gross_income]
    wic_gross_income = wic_gross_income.gsub(/[^0-9\.]/, '')


    if wic_gross_income !~ /\D/
      wic_gross_income = wic_gross_income.to_i
    else
      if wic_gross_income.include?("dollars")
        wic_gross_income.slice!"dollars"
      end
      wic_gross_income = wic_gross_income.in_numbers
    end


    wic_status = params[:wic_status]

    if  wic_gross_income.present? && wic_household_size.present?

      wic_eligibility = Wic.find_by({ :wic_household_size => wic_household_size })

      if wic_gross_income < wic_eligibility.wic_gross_income
        if wic_status != 'none of the above'
          @eligible = true
        end
      end

    else
       redirect_to :back, :notice => "All fields are required."
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
