class MedicaidsController < ApplicationController
  before_action :set_medicaid, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  def new
    @medicaid = Medicaid.new
    if params[:data].present? 
      @d = MedicaidData.new(JSON.parse(params[:data])) 
    else 
      @d = MedicaidData.new
    end

    @current_user = current_user
  end

  def create
    @d = MedicaidData.new
    if params[:medicaid_household_size] !~ /\D/  # returns true if all numbers
      medicaid_household_size = params[:medicaid_household_size].to_i
      @d.household_size = medicaid_household_size
    else
      medicaid_household_size = params[:medicaid_household_size].in_numbers
      @d.household_size = medicaid_household_size
    end

    medicaid_gross_income = params[:medicaid_gross_income]
    medicaid_gross_income = medicaid_gross_income.gsub(/[^0-9\.]/, '')
    if medicaid_gross_income !~ /\D/
      medicaid_gross_income = medicaid_gross_income.to_i
      @d.monthly_gross_income = medicaid_gross_income
    else
      if medicaid_gross_income.include?("dollars")
        medicaid_gross_income.slice!"dollars"
      end
      medicaid_gross_income = medicaid_gross_income.in_numbers
      @d.monthly_gross_income = medicaid_gross_income
    end

    medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => medicaid_household_size})

    if params[:citizen] == 'no'
      @eligible = 'maybe'
      @d.medicaid_eligibility_status = @eligible
    elsif params[:citizen] == 'yes'
      if medicaid_gross_income < medicaid_eligibility.medicaid_gross_income
        @eligible = 'yes'
       @d.medicaid_eligibility_status = @eligible
      else
        @eligible = 'no'
       @d.medicaid_eligibility_status = @eligible
      end
    end

   #RESOURCE LOOKUP
   @user_zipcode = params[:zipcode]
   @zipcode = @user_zipcode << ".0"
   @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

   if @lafcenter.present?
   else
     @lafcenter = LafCenter.find_by(:center => "King Community Service Center")
     @laf_disclaimer = "We do not have an estimation of the nearest center that is in range for you at this time. But we recommend going to the center below."
   end

    primarycare = []
    ServiceCenter.all.each do |center|
      if center.description.match("primary care")
        primarycare.push(center)
      end
    end

    @pb_zipcode = @user_zipcode.chomp(".0")
      @resources = primarycare
      @resources_zip = []

      primarycare.each do |center|
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

   #DATA STORAGE
   @d.user_location = params[:user_location]
   @d.phone_number = params[:phone_number] if params[:phone_number].present?
   @d.citizen = params[:citizen]
   @d.zipcode = @user_zipcode.chop.chop
   @d.save

   @d_json = @d.attributes.to_json

    if params[:citizen].present?
    else
       flash.now[:alert] = 'Looks like you forgot to answer the citizenship question! Please answer all questions below.'
      render "new"
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
