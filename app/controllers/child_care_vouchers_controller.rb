class ChildCareVouchersController < ApplicationController
  before_action :set_child_care_voucher, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /child_care_vouchers/new
 def new
    @child_care_voucher = ChildCareVoucher.new
    @d = ChildCareVoucherData.new
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

    if ccdf_gross_income.present? && ccdf_dependent_no.present?

        ccdf_eligibility = ChildCareVoucher.find_by({ :ccdf_dependent_no => ccdf_dependent_no })


       p "ccdf_gross_income = #{ccdf_gross_income}"
       p "ccdf_eligibility.ccdf_gross_income = #{ccdf_eligibility.ccdf_gross_income}"

       if ccdf_gross_income < ccdf_eligibility.ccdf_gross_income
         @eligible = true
         @d.eligibility_status = "yes"
       else
          @d.eligibility_status = "no"
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

     childcare = []
     ServiceCenter.all.each do |center|
       if center.description.match("child care")
         childcare.push(center)
       end
     end


     @pb_zipcode = @user_zipcode.chomp(".0")
       @child_resources = childcare
       @child_resources_zip = []

       childcare.each do |center|
         if center.zip.match(@pb_zipcode)
           @child_resources_zip.push(center)
         end
       end


       #@child_resources.where(:zip => @user_zipcode)

       #in this case there are 2 medical centers in the user's zip
       if @child_resources_zip.count >= 2
          @child_resources = @child_resources_zip
       end
       #in this case there is 1 medical center in the user's zip
       if @child_resources_zip.count == 1
          @child_resources_first = @child_resources_zip.first
          @child_resources_second = @child_resources.first
       end
       #in this caser there are no medical centers in the user's zip
       if  @child_resources_zip.count == 0
           @child_resources_first = @child_resources.first
           @child_resources_second = @child_resources.second
       end

  # DATA STORAGE
    @d.user_location = params[:user_location]
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.zipcode = params[:zipcode]
    @d.save
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
