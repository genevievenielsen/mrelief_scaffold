class EarlyHeadStartsController < ApplicationController
  before_action :set_early_head_start, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /early_head_starts/new
 def new
    @early_head_start = EarlyHeadStart.new
    @e = EarlyHeadStartData.new
  end

  def create
    @e = EarlyHeadStartData.new
   if params[:ehs_dependent_no] !~ /\D/  # returns true if all numbers
      ehs_dependent_no = params[:ehs_dependent_no].to_i
      @e.dependent_no = ehs_dependent_no
    else
      ehs_dependent_no = params[:ehs_dependent_no].in_numbers
      @e.dependent_no = ehs_dependent_no
    end


    ehs_gross_income = params[:ehs_gross_income]
    ehs_gross_income = ehs_gross_income.gsub(/[^0-9\.]/, '').to_i

    if ehs_gross_income !~ /\D/
      ehs_gross_income = ehs_gross_income.to_i
      @e.gross_monthly_income = ehs_gross_income
    else
      if ehs_gross_income.include?("dollars")
        ehs_gross_income.slice!"dollars"
      end
      ehs_gross_income = ehs_gross_income.in_numbers
      @e.gross_monthly_income = ehs_gross_income
    end


    if  ehs_gross_income.present? && ehs_dependent_no.present?

      ehs_eligibility = EarlyHeadStart.find_by({ :ehs_dependent_no => ehs_dependent_no })


       p "ehs_gross_income = #{ehs_gross_income}"
       p "ehs_eligibility.ehs_gross_income = #{ehs_eligibility.ehs_gross_income}"

       if ehs_gross_income < ehs_eligibility.ehs_gross_income
         @eligible = true
         @e.eligibility_status = "yes"
       else
          @e.eligibility_status = "no"
        end
     else
       redirect_to :back, :notice => "All fields are required."
     end
     @user_zipcode = params[:zipcode]
     @zipcode = @user_zipcode << ".0"
     @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

     if @lafcenter.present?
     else
       @lafcenter = LafCenter.find_by(:id => 10)
     end

      earlyheadstart = []
      ServiceCenter.all.each do |center|
        if center.description.match("early head start")
          earlyheadstart.push(center)
        end
      end

      @pb_zipcode = @user_zipcode.chomp(".0")
        @earlyheadstart_resources = earlyheadstart
        @earlyheadstart_resources_zip = []

        earlyheadstart.each do |center|
          if center.zip.match(@pb_zipcode)
            @earlyheadstart_resources_zip.push(center)
          end
        end

      #in this case there are 2 medical centers in the user's zip
      if @earlyheadstart_resources_zip.count >= 2
         @earlyheadstart_resources = @earlyheadstart_resources_zip
      end
      #in this case there is 1 medical center in the user's zip
      if @earlyheadstart_resources_zip.count == 1
         @earlyheadstart_resources_first = @earlyheadstart_resources_zip.first
         @earlyheadstart_resources_second = @earlyheadstart_resources.first
      end
      #in this caser there are no medical centers in the user's zip
      if  @earlyheadstart_resources_zip.count == 0
          @earlyheadstart_resources_first = @earlyheadstart_resources.first
          @earlyheadstart_resources_second = @earlyheadstart_resources.second
      end

      @e.user_location = params[:user_location]
      @e.phone_number = params[:phone_number] if params[:phone_number].present?
      @e.zipcode = params[:zipcode]
      @e.save
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_early_head_start
      @early_head_start = EarlyHeadStart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def early_head_start_params
      params.require(:early_head_start).permit(:ehs_dependent_no, :ehs_gross_income)
    end
end
