class ChildCareVouchersController < ApplicationController
  before_action :set_child_care_voucher, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /child_care_vouchers/new
 def new
    @child_care_voucher = ChildCareVoucher.new
    if params[:data].present? 
      @d = ChildCareVoucherData.new(JSON.parse(params[:data])) 
    else 
      @d = ChildCareVoucherData.new
    end
    @current_user = current_user
  end

  def create
    @d = ChildCareVoucherData.new
    # if the params hash contains a letter
    if params[:ccdf_dependent_no] !~ /\D/  # returns true if all numbers
      ccdf_dependent_no = params[:ccdf_dependent_no].to_i
      @d.dependent_no = ccdf_dependent_no
    else
      ccdf_dependent_no = params[:ccdf_dependent_no].in_numbers
      @d.dependent_no = ccdf_dependent_no
    end


    ccdf_gross_income = params[:ccdf_gross_income]
    ccdf_gross_income = ccdf_gross_income.gsub(/[^0-9\.]/, '')


    if ccdf_gross_income !~ /\D/
      ccdf_gross_income = ccdf_gross_income.to_i
      @d.gross_monthly_income = ccdf_gross_income
    else
      if ccdf_gross_income.include?("dollars")
        ccdf_gross_income.slice!"dollars"
      end
      ccdf_gross_income = ccdf_gross_income.in_numbers
      @d.gross_monthly_income = ccdf_gross_income
    end

     if params[:tanf].present?
      @d.tanf = true
    end
    if params[:teen_parent].present?
      @d.teen_parent = true
    end
    if params[:special_needs].present?
      @d.special_needs = true
    end
    if params[:child] == "yes"
      @d.child = true
    end
    if params[:employment] == "yes"
      @d.employed = true
    end

    if @d.tanf == true || @d.teen_parent == true || @d.special_needs == true
      if @d.child == true
        if @d.employed == true
          income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => ccdf_dependent_no})
          if ccdf_gross_income < income_row.income_type4
            @eligible = true
          else
             @eligible = false
          end
        else
          # not employed 
          @eligible = false
        end
      else
        # no children 
        @eligible = false
      end
    else
      @eligible = false
    end

    
    if @eligible == true 
      @d.eligibility_status = "yes"
    else
       @d.eligibility_status = "no"
    end

     childcare = []
     ServiceCenter.all.each do |center|
       if center.description.match("child care")
         childcare.push(center)
       end
     end

     @user_zipcode = params[:zipcode]
     @zipcode = @user_zipcode << ".0"
     @pb_zipcode = @user_zipcode.chomp(".0")
       @resources = childcare
       @resources_zip = []

       childcare.each do |center|
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

  # DATA STORAGE
    @d.user_location = params[:user_location]
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.zipcode = @user_zipcode.chop.chop
    @d.save

    @d_json = @d.attributes.to_json

end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child_care_voucher
      @child_care_voucher = ChildCareVoucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_care_voucher_params
      params.require(:child_care_voucher).permit(:ccdf_dependent_no, :ccdf_eligible_children, :ccdf_gross_income)
    end
end
