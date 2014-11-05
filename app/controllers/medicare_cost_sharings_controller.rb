class MedicareCostSharingsController < ApplicationController
  before_action :set_medicare_cost_sharing, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token


  def new
    @medicare_cost_sharing = MedicareCostSharing.new
  end

  def create

    # @medicare_cost_sharing.household_size = params[:household_size]
    # @medicare_cost_sharing.medicare_cost_sharing = params[:medicare_cost_sharing]
    # @medicare_cost_sharing.premium_only = params[:premium_only]

     # this is the words into numbers logic
    if params[:household_size] !~ /\D/  # returns true if all numbers
      household_size = params[:household_size].to_i
    else
      household_size = params[:household_size].in_numbers
    end

    if params[:medicare_household_size] !~ /\D/
      medicare_household_size = params[:medicare_household_size].to_i
    else
      medicare_household_size = params[:medicare_household_size].in_numbers
    end

    monthly_income = params[:monthly_income]
    monthly_income = monthly_income.gsub(/[^0-9\.]/, '')

    if monthly_income !~ /\D/
      monthly_income = monthly_income.to_i
    else
      if monthly_income.include?("dollars")
        monthly_income.slice!"dollars"
      end
      monthly_income = monthly_income.in_numbers
    end

    assets = params[:assets]
    assets = assets.gsub(/[^0-9\.]/, '')

    if assets !~ /\D/
      assets = assets.to_i
    else
      if assets.include?("dollars")
        assets.slice!"dollars"
      end
      assets = assets.in_numbers
    end

    #this is the logic for the form
    if medicare_household_size == 0
      @eligible = "no"

    elsif household_size == 1 && assets > 7160
      @eligible = "no"

    elsif household_size > 1 && assets > 10750
      @eligible = "no"

    else
      if medicare_household_size == 1
        monthly_income = monthly_income - 25
      elsif medicare_household_size == 2
        monthly_income = monthly_income - 50
      end

      medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => household_size })

      if monthly_income < medicare_sharing_eligibility.premium_only
        @eligible = "yes"

        if monthly_income < medicare_sharing_eligibility.medicare_cost_sharing
          @eligible_p_d_c = "yes"

        elsif monthly_income >= medicare_sharing_eligibility.medicare_cost_sharing
          @eligible_p = "yes"

        end

      end

     end


     # this is the logic for the zipcode and the laf center
      @user_zipcode = params[:zipcode]
      @zipcode = @user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      @zipcode = @lafcenter.zipcode.chomp(".0")

      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end


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

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_medicare_cost_sharing
  #     @medicare_cost_sharing = MedicareCostSharing.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def medicare_cost_sharing_params
  #     params.require(:medicare_cost_sharing).permit(:household_size, :medicare_cost_sharing, :premium_only)
  #   end
end
