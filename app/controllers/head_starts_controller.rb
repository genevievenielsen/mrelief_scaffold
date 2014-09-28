class HeadStartsController < ApplicationController
  before_action :set_head_start, only: [:show, :edit, :update, :destroy]



  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later


  def new
    @head_start = HeadStart.new
  end

  def create
     # if the params hash contains a letter
    if params[:hs_dependent_no] !~ /\D/  # returns true if all numbers
      hs_dependent_no = params[:hs_dependent_no].to_i
    else
      hs_dependent_no = params[:hs_dependent_no].in_numbers
    end

    hs_gross_income = params[:hs_gross_income]
    hs_gross_income = hs_gross_income.gsub(/[^0-9\.]/, '').to_i

    if hs_gross_income !~ /\D/
      hs_gross_income = hs_gross_income.to_i
    else
      if hs_gross_income.include?("dollars")
        hs_gross_income.slice!"dollars"
      end
      hs_gross_income = hs_gross_income.in_numbers
    end


    if  hs_gross_income.present? && hs_dependent_no.present?

    hs_eligibility = HeadStart.find_by({ :hs_dependent_no => hs_dependent_no })


       p "hs_gross_income = #{hs_gross_income}"
       p "hs_eligibility.hs_gross_income = #{hs_eligibility.hs_gross_income}"

       if hs_gross_income < hs_eligibility.hs_gross_income
         if params[:child_birthdate]  == "yes"
            @eligible = true
          end
       else

      end
    end #closes if statement
  end #closes end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_head_start
      @head_start = HeadStart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def head_start_params
      params.require(:head_start).permit(:hs_dependent_no, :hs_gross_income)
    end
end
