class RentalAssistancesController < ApplicationController
  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later
  before_action :set_rental_assistance, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  def new
    @rental_assistance = RentalAssistance.new
  end

  def create
    r = RentalAssistanceData.new
    if params[:rental_dependent_no] !~ /\D/  # returns true if all numbers
      rental_dependent_no = params[:rental_dependent_no].to_i
      r.dependent_no = rental_dependent_no
    else
      rental_dependent_no = params[:rental_dependent_no].in_numbers
      r.dependent_no = rental_dependent_no
    end

    rental_gross_income = params[:rental_gross_income]
    rental_gross_income = rental_gross_income.gsub(/[^0-9\.]/, '').to_i
    if rental_gross_income !~ /\D/
      rental_gross_income = rental_gross_income.to_i
      r.ninety_day_gross_income = rental_gross_income
    else
      if rental_gross_income.include?("dollars")
        rental_gross_income.slice!"dollars"
      end
      rental_gross_income = rental_gross_income.in_numbers
      r.ninety_day_gross_income = rental_gross_income
    end

    if rental_gross_income.present? && rental_dependent_no.present?
      rental_eligibility = RentalAssistance.find_by({ :rental_dependent_no => rental_dependent_no })
      rental_cut_off =  rental_eligibility.rental_gross_income
      rental_cut_off_plus_200 = rental_eligibility.rental_gross_income + 200

       p "rental_gross_income = #{rental_gross_income}"
       p "rental_eligibility.rental_gross_income = #{rental_eligibility.rental_gross_income}"

       if params[:lease] == "no" || params[:next_rent] == "no"
         @eligible = "no"
         r.rental_eligibility_status = @eligible
       elsif params[:lease] == "yes"
        if rental_gross_income < rental_eligibility.rental_gross_income && params[:rental_status] != "none of the above"
          @eligible = "yes"
          r.rental_eligibility_status = @eligible
        elsif rental_gross_income< rental_cut_off_plus_200 && rental_gross_income >= rental_cut_off && params[:rental_status] != "none of the above"
          @eligible = "maybe"
          r.rental_eligibility_status = @eligible
        else
          @eligible = "no"
          r.rental_eligibility_status = @eligible
         end
        end # closes the if statement about the lease agreement
      end #closes first if statement
      if params[:rental_status] == "medical circumstance"
        @medical_circumstance = "yes"
      elsif params[:rental_status] == "a victim of natural disaster or fire"
        @natural_disaster = "yes"
      elsif params[:rental_status] == "have experienced a temporary loss of income"
        @temporary_loss = "yes"
      elsif params[:rental_status] == "a victim of domestic violence"
        @domestic_violence = "yes"
      end

      # DATA STORAGE
      r.user_location = params[:user_location]
      r.phone_number = params[:phone_number] if params[:phone_number].present?
      r.name_on_lease = params[:lease]
      r.rental_status = params[:rental_status]
      r.zipcode = params[:zipcode]
      r.save

      @user_zipcode = params[:zipcode]
      @zipcode = @user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
        @laf_disclaimer = "We do not have an estimation of the nearest center that is in range for you at this time. But we recommend going to the center below."
      end

      housing = []
      ServiceCenter.all.each do |center|
        if center.description.match("housing")
          housing.push(center)
        end
      end

      @pb_zipcode = @user_zipcode.chomp(".0")
        @housing_resources = housing
        @housing_resources_zip = []

        housing.each do |center|
          if center.zip.match(@pb_zipcode)
            @housing_resources_zip.push(center)
          end
        end

        #in this case there are 2 housing centers in the user's zip
        if @housing_resources_zip.count >= 2
           @housing_resources = @housing_resources_zip
        end

        #in this case there is 1 aabd center in the user's zip
        if @housing_resources_zip.count == 1
           @housing_resources_first = @housing_resources_zip.first
           @housing_resources_second = @housing_resources.first
        end

        #in this caser there are no aabd centers in the user's zip
        if  @housing_resources_zip.count == 0
            @housing_resources_first = @housing_resources.first
            @housing_resources_second = @housing_resources.second
        end

    end #closes method


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental_assistance
      @rental_assistance = RentalAssistance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_assistance_params
      params.require(:rental_assistance).permit(:rental_dependent_no, :rental_gross_income, :rental_status)
    end
end
