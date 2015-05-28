class MedicareCostSharingsController < ApplicationController
  before_action :set_medicare_cost_sharing, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  def new
    @medicare_cost_sharing = MedicareCostSharing.new
    @d = MedicareCostSharingData.new
    @current_user = current_user
  end

  def create
    @m = MedicareCostSharingData.new
    if params[:household_size] !~ /\D/  # returns true if all numbers
      household_size = params[:household_size].to_i
      @m.household_size = household_size
    else
      household_size = params[:household_size].in_numbers
      @m.household_size = household_size
    end

    if params[:medicare_household_size] !~ /\D/
      medicare_household_size = params[:medicare_household_size].to_i
      @m.medicare_household_size = medicare_household_size
    else
      medicare_household_size = params[:medicare_household_size].in_numbers
      @m.medicare_household_size = medicare_household_size
    end

    monthly_income = params[:monthly_income]
    monthly_income = monthly_income.gsub(/[^0-9\.]/, '')
    if monthly_income !~ /\D/
      monthly_income = monthly_income.to_i
      @m.monthly_gross_income = monthly_income
    else
      if monthly_income.include?("dollars")
        monthly_income.slice!"dollars"
      end
      monthly_income = monthly_income.in_numbers
      @m.monthly_gross_income = monthly_income
    end

    assets = params[:assets]
    assets = assets.gsub(/[^0-9\.]/, '')
    if assets !~ /\D/
      assets = assets.to_i
      @m.assets = assets
    else
      if assets.include?("dollars")
        assets.slice!"dollars"
      end
      assets = assets.in_numbers
      @m.assets = assets
    end

    #this is the logic for the form
    if medicare_household_size == 0
      @eligible = "no"
      @m.medicare_cost_sharing_eligibility_status = @eligible
    elsif household_size == 1 && assets > 7280
      @eligible = "no"
      @m.medicare_cost_sharing_eligibility_status = @eligible
    elsif household_size > 1 && assets > 10930
      @eligible = "no"
      @m.medicare_cost_sharing_eligibility_status = @eligible
    else
      if medicare_household_size == 1
        monthly_income = monthly_income - 25
      elsif medicare_household_size == 2
        monthly_income = monthly_income - 50
      end

      medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => household_size })
      if monthly_income < medicare_sharing_eligibility.premium_only
        @eligible = "yes"
        @m.medicare_cost_sharing_eligibility_status = @eligible
        if monthly_income < medicare_sharing_eligibility.medicare_cost_sharing
          @eligible_p_d_c = "yes"
        elsif monthly_income >= medicare_sharing_eligibility.medicare_cost_sharing
          @eligible_p = "yes"
        end
      end
     end

     #DATA STORAGE
     @m.phone_number = params[:phone_number] if params[:phone_number].present?
     @m.user_location = params[:user_location]
     @m.zipcode = params[:zipcode]
     @m.save

     # this is the logic for the zipcode and the laf center
      @user_zipcode = params[:zipcode]
      @zipcode = @user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)


      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
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
