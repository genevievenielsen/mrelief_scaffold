class RentalAssistancesController < ApplicationController
  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later
  before_action :set_rental_assistance, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  def new
    @rental_assistance = RentalAssistance.new
    @d = RentalAssistanceData.new
    @current_user = current_user
  end

  def create
    @d = RentalAssistanceData.new
    if params[:rental_dependent_no] !~ /\D/  # returns true if all numbers
      rental_dependent_no = params[:dependent_no].to_i
      @d.dependent_no = rental_dependent_no
    else
      rental_dependent_no = params[:dependent_no].in_numbers
      @d.dependent_no = rental_dependent_no
    end

    rental_gross_income = params[:rental_gross_income]
    rental_gross_income = rental_gross_income.gsub(/[^0-9\.]/, '').to_i
    if rental_gross_income !~ /\D/
      rental_gross_income = rental_gross_income.to_i
      @d.ninety_day_gross_income = rental_gross_income
    else
      if rental_gross_income.include?("dollars")
        rental_gross_income.slice!"dollars"
      end
      rental_gross_income = rental_gross_income.in_numbers
      @d.ninety_day_gross_income = rental_gross_income
    end

    if rental_gross_income.present? && rental_dependent_no.present?
      rental_eligibility = RentalAssistance.find_by({ :rental_dependent_no => rental_dependent_no })
      rental_cut_off =  rental_eligibility.rental_gross_income
      rental_cut_off_plus_200 = rental_eligibility.rental_gross_income + 200

       p "rental_gross_income = #{rental_gross_income}"
       p "rental_eligibility.rental_gross_income = #{rental_eligibility.rental_gross_income}"

       if params[:lease] == "no" || params[:next_rent] == "no"
         @eligible = "no"
         @d.rental_eligibility_status = @eligible
       elsif params[:lease] == "yes"
        if rental_gross_income < rental_eligibility.rental_gross_income && params[:rental_status] != "none of the above"
          @eligible = "yes"
          @d.rental_eligibility_status = @eligible
        elsif rental_gross_income< rental_cut_off_plus_200 && rental_gross_income >= rental_cut_off && params[:rental_status] != "none of the above"
          @eligible = "maybe"
          @d.rental_eligibility_status = @eligible
        else
          @eligible = "no"
          @d.rental_eligibility_status = @eligible
         end
        end # closes the if statement about the lease agreement
      end #closes first if statement
      if params[:medical].present?
        @medical_circumstance = "yes"
      end
      if params[:natural_disaster].present?
        @natural_disaster = "yes"
      end
      if params[:eviction].present?
        @eviction = "yes"
      end
      if params[:income].present?
        @temporary_loss = "yes"
      end
      if params[:domestic_violence] == "a victim of domestic violence"
        @domestic_violence = "yes"
      end

      # DATA STORAGE
      @d.user_location = params[:user_location]
      @d.phone_number = params[:phone_number] if params[:phone_number].present?
      @d.name_on_lease = params[:lease]
      @d.next_month_rent = params[:next_rent]
      @d.rental_status = params[:rental_status]
      @d.zipcode = params[:zipcode]
      @d.save

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
        @resources = housing
        @resources_zip = []

        housing.each do |center|
          if center.zip.match(@pb_zipcode)
            @resources_zip.push(center)
          end
        end

        #in this case there are 2 housing centers in the user's zip
        if @resources_zip.count >= 2
           @resources = @resources_zip
        end

        #in this case there is 1 aabd center in the user's zip
        if @resources_zip.count == 1
           @resources_first = @resources_zip.first
           @resources_second = @resources.first
        end

        #in this caser there are no aabd centers in the user's zip
        if  @resources_zip.count == 0
            @resources_first = @resources.first
            @resources_second = @resources.second
        end

      if params[:lease].present? && params[:next_rent].present?
      else
         flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
        render "new"
      end

    end #closes method

  def documents

    @medical_circumstance = params[:medical_circumstance] 
    @natural_disaster = params[:natural_disaster]
    @temporary_loss = params[:temporary_loss]
    @domestic_violence = params[:domestic_violence]
    @eviction = params[:eviction]

  end

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
