class MedicaidsController < ApplicationController
  before_action :set_medicaid, only: [:show, :edit, :update, :destroy]


    def new
    @medicaid = Medicaid.new
  end


  def create
    if params[:medicaid_household_size] !~ /\D/  # returns true if all numbers
      medicaid_household_size = params[:medicaid_household_size].to_i
    else
      medicaid_household_size = params[:medicaid_household_size].in_numbers
    end

    medicaid_gross_income = params[:medicaid_gross_income]
    medicaid_gross_income = medicaid_gross_income.gsub(/[^0-9\.]/, '')

    if medicaid_gross_income !~ /\D/
      medicaid_gross_income = medicaid_gross_income.to_i
    else
      if medicaid_gross_income.include?("dollars")
        medicaid_gross_income.slice!"dollars"
      end
      medicaid_gross_income = medicaid_gross_income.in_numbers
    end

    medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => medicaid_household_size})

      p "medicaid_gross_income = #{medicaid_gross_income}"
      p "medicaid_eligibility.medicaid_gross_income = #{medicaid_eligibility.medicaid_gross_income}"


    if params[:citizen] == 'no'
      @eligible = 'maybe'
    elsif params[:citizen] == 'yes'
        if medicaid_gross_income < medicaid_eligibility.medicaid_gross_income
          @eligible = 'yes'
        else
          @eligible = 'no'
        end
    end

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medicaid
      @medicaid = Medicaid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medicaid_params
      params.require(:medicaid).permit(:medicaid_household_size, :medicaid_gross_income)
    end
end
