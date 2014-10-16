class MedicaidsController < ApplicationController
  before_action :set_medicaid, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token


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

   @user_zipcode = params[:zipcode]
   @zipcode = @user_zipcode << ".0"
   @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

    primarycare = []
    ServiceCenter.all.each do |center|
      if center.description.match("primary care")
        primarycare.push(center)
      end
    end


    @pb_zipcode = @user_zipcode.chomp(".0")
      @medical_resources = primarycare
      @medical_resources_zip = []

      primarycare.each do |center|
        if center.zip.match(@pb_zipcode)
          @medical_resources_zip.push(center)
        end
      end


      #@medical_resources.where(:zip => @user_zipcode)

        #in this case there are 2 medical centers in the user's zip
        if @medical_resources_zip.count >= 2
           @medical_resources = @medical_resources_zip
        end

        #in this case there is 1 medical center in the user's zip
        if @medical_resources_zip.count == 1
           @medical_resources_first = @medical_resources_zip.first
           @medical_resources_second = @medical_resources.first
        end

        #in this caser there are no medical centers in the user's zip
        if  @medical_resources_zip.count == 0
            @medical_resources_first = @medical_resources.first
            @medical_resources_second = @medical_resources.second
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
