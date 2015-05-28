class AabdCashesController < ApplicationController
  before_action :set_aabd_cash, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /aabd_cashes/new
  def new
    @aabd_cash = AabdCash.new
    @d = AabdCashData.new
    @current_user = current_user
  end

  # POST /aabd_cashes
  # POST /aabd_cashes.json
  def create
    @d = AabdCashData.new
    # this is the words into numbers logic
    if params[:aabd_household_size] !~ /\D/  # returns true if all numbers
      aabd_household_size = params[:aabd_household_size].to_i
      @d.household_size = aabd_household_size
    else
      aabd_household_size = params[:aabd_household_size].in_numbers
      @d.household_size = aabd_household_size
    end

    if params[:age] !~ /\D/
      age = params[:age].to_i
      @d.age = age
    else
      age = params[:age].in_numbers
      @d.age = age
    end

    aabd_net_income = params[:aabd_net_income]
    aabd_net_income = aabd_net_income.gsub(/[^0-9\.]/, '')
    if aabd_net_income !~ /\D/
      aabd_net_income = aabd_net_income.to_i
      @d.thirty_day_net_income = aabd_net_income
    else
      if aabd_net_income.include?("dollars")
        aabd_net_income.slice!"dollars"
      end
      aabd_net_income = aabd_net_income.in_numbers
      @d.thirty_day_net_income = aabd_net_income
    end

    aabd_benefits = params[:aabd_benefits]
    aabd_benefits = aabd_benefits.gsub(/[^0-9\.]/, '')
    if aabd_benefits !~ /\D/
      aabd_benefits = aabd_benefits.to_i
      @d.government_benefits = aabd_benefits
    else
      if aabd_benefits.include?("dollars")
        aabd_benefits.slice!"dollars"
      end
      aabd_benefits = aabd_benefits.in_numbers
      @d.government_benefits = aabd_benefits
    end

    aabd_assets = params[:aabd_assets]
    aabd_assets = aabd_assets.gsub(/[^0-9\.]/, '')
    if aabd_assets !~ /\D/
      aabd_assets = aabd_assets.to_i
      @d.assets = aabd_assets
    else
      if aabd_assets.include?("dollars")
        aabd_assets.slice!"dollars"
      end
      aabd_assets = aabd_assets.in_numbers
      @d.assets = aabd_assets
    end

    # if they are receiving disability payment proceed with logic
    # if they are NOT receiving disability payment but are over 65, proceed with logic
    if params[:disabled] != 'No' || age > 65
      if aabd_household_size == 1
        if aabd_net_income + aabd_benefits < 833.38
          if aabd_assets < 2000
            @eligible = 'yes'
            @d.aabd_eligibility_status = @eligible
          else # exceed asset limit
            @eligible = 'no'
            @d.aabd_eligibility_status = @eligible
          end
        else # exceed income limit
          @eligible = "no"
          @d.aabd_eligibility_status = @eligible
        end

      elsif aabd_household_size == 2
        if aabd_net_income + aabd_benefits < 736.38
          if aabd_assets < 3000
            @eligible = 'yes'
            @d.aabd_eligibility_status = @eligible
          else # exceed asset limit
            @eligible = 'no'
            @d.aabd_eligibility_status = @eligible
          end
        else # exceed income limit
          @eligible = "no"
          @d.aabd_eligibility_status = @eligible
        end

      else #household size is greater than 2
        if aabd_net_income + aabd_benefits < 736.38
          @eligible = 'maybe'
          @d.aabd_eligibility_status = @eligible
        else
          @eligible = 'no'
          @d.aabd_eligibility_status = @eligible
        end
      end
    else
      @eligible = 'no'
      @d.aabd_eligibility_status = @eligible
    end
    # if they are NOT receiving payment and are NOT over 65, not eligible

    if params[:citizen] == 'no'
      @eligible = 'maybe'
      @d.aabd_eligibility_status = @eligible
    end

    # DATA STORAGE
    @d.user_location = params[:user_location]
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.citizen = params[:citizen]
    @d.disabled_status = params[:disabled]
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

    aabd = []
    ServiceCenter.all.each do |center|
      if center.description.match("senior services")
        unless center.description.match("child care")
        aabd.push(center)
        end
      end
      if center.description.match("disabled")
        unless center.description.match("child care")
        aabd.push(center)
        end
      end
    end

    @pb_zipcode = @user_zipcode.chomp(".0")
      @resources = aabd
      @resources_zip = []

      aabd.each do |center|
        if center.zip.match(@pb_zipcode)
          @resources_zip.push(center)
        end
      end

      #in this case there are 2 aabd centers in the user's zip
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

    if params[:citizen].present? && params[:disabled].present?
    else
       flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
      render "new"
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aabd_cash
      @aabd_cash = AabdCash.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aabd_cash_params
      params[:aabd_cash]
    end
end
