class AllKidsController < ApplicationController
  before_action :set_all_kid, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /all_kids
  # GET /all_kids.json
  def index
    @all_kids = AllKid.all
  end

  # GET /all_kids/new
  def new
    @all_kid = AllKid.new
  end

  # POST /all_kids
  # POST /all_kids.json
  def create
    @all_kid = AllKid.new#(all_kid_params)

    # if the params hash contains a letter
    if params[:kids_household_size] !~ /\D/  # returns true if all numbers
      kids_household_size = params[:kids_household_size].to_i
    else
      kids_household_size = params[:kids_household_size].in_numbers
    end


    kids_gross_income = params[:kids_gross_income]
    kids_gross_income = kids_gross_income.gsub(/[^0-9\.]/, '').to_i

    if kids_gross_income !~ /\D/
      kids_gross_income = kids_gross_income.to_i
    else
      if kids_gross_income.include?("dollars")
        kids_gross_income.slice!"dollars"
      end
      kids_gross_income = kids_gross_income.in_numbers
    end

    if kids_gross_income.present? && kids_household_size.present?

      kids_eligibility = AllKid.find_by({ :kids_household_size => kids_household_size })

       p "kids_gross_income = #{kids_gross_income}"

       if kids_gross_income < kids_eligibility.premium_1_gross_income
         @eligible = true
       end

       if @eligible = true
        # now find out which version they are eligible for
        if kids_gross_income <= kids_eligibility.assist_gross_income
          @assist_eligible = true
        elsif kids_gross_income <= kids_eligibility.share_gross_income && kids_gross_income > kids_eligibility.assist_gross_income
          @share_eligible = true
        elsif kids_gross_income <= kids_eligibility.premium_1_gross_income && kids_gross_income > kids_eligibility.share_gross_income
          @premium1_eligible = true
        end
       end

          #this is the logic for premium 2


        if kids_gross_income <= kids_eligibility.premium_2_gross_income && kids_gross_income > kids_eligibility.premium_1_gross_income
            if params["status"] == 'none'
               @eligible = false
            else
              @eligible = true
              @premium2_eligible = true
            end

        end

        if kids_gross_income > kids_eligibility.premium_2_gross_income
          @eligible = false
        end

    end


  end



  # DELETE /all_kids/1
  # DELETE /all_kids/1.json
  def destroy
    @all_kid.destroy
    respond_to do |format|
      format.html { redirect_to all_kids_url, notice: 'All kid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_all_kid
      @all_kid = AllKid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def all_kid_params
      params.require(:all_kid).permit(:kids_household_size, :assist_gross_income, :share_gross_income, :premium_1_gross_income, :premium_2_gross_income)
    end
end
