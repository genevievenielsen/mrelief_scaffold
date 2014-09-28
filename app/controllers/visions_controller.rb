class VisionsController < ApplicationController
  before_action :set_vision, only: [:show, :edit, :update, :destroy]




  def new
    @vision = Vision.new
  end

  def create
    # if the params hash contains a letter
    if params[:vision_household_size] !~ /\D/  # returns true if all numbers
      vision_household_size = params[:vision_household_size].to_i
    else
      vision_household_size = params[:vision_household_size].in_numbers
    end

   vision_gross_income = params[:vision_gross_income]
   vision_gross_income = vision_gross_income.gsub(/[^0-9\.]/, '').to_i

   if vision_gross_income !~ /\D/
      vision_gross_income = vision_gross_income.to_i
    else
      if vision_gross_income.include?("dollars")
        vision_gross_income.slice!"dollars"
      end
      vision_gross_income = vision_gross_income.in_numbers
    end

   case_management = params[:case_management]

    if  vision_gross_income.present? && vision_household_size.present?

      vision_eligibility = Vision.find_by({ :vision_household_size => vision_household_size })

      if vision_gross_income < vision_eligibility.vision_gross_income

        if case_management == 'yes'
          @eligible = true
        end
      else

      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vision
      @vision = Vision.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vision_params
      params.require(:vision).permit(:vision_gross_income, :vision_household_size)
    end
end
