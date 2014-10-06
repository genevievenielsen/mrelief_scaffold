class RtaFreeRidesController < ApplicationController
  before_action :set_rta_free_ride, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  def new
    @rta_free_ride = RtaFreeRide.new
  end

  def create

    if params[:rta_dependent_no] !~ /\D/  # returns true if all numbers
      rta_dependent_no = params[:rta_dependent_no].to_i
    else
      rta_dependent_no = params[:rta_dependent_no].in_numbers
    end

    rta_gross_income = params[:rta_gross_income]
    rta_gross_income = rta_gross_income.gsub(/[^0-9\.]/, '').to_i

    if rta_gross_income !~ /\D/
      rta_gross_income = rta_gross_income.to_i
    else
      if rta_gross_income.include?("dollars")
        rta_gross_income.slice!"dollars"
      end
      rta_gross_income = rta_gross_income.in_numbers
    end

    if  rta_gross_income.present? && rta_dependent_no.present?
         rta_eligibility = RtaFreeRide.find_by({ :rta_dependent_no => rta_dependent_no })

       p "rta_gross_income = #{rta_gross_income}"
       p "rta_eligibility.rta_gross_income = #{rta_eligibility.rta_gross_income}"

       if rta_gross_income < rta_eligibility.rta_gross_income
         @eligible = true
       else
       end
     else
       redirect_to :back, :notice => "All fields are required."
     end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rta_free_ride
      @rta_free_ride = RtaFreeRide.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rta_free_ride_params
      params.require(:rta_free_ride).permit(:rta_dependent_no, :rta_gross_income)
    end
end
