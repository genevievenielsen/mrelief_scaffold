class RtaFreeRidesController < ApplicationController
  before_action :set_rta_free_ride, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  def new
    @rta_free_ride = RtaFreeRide.new
  end

  def create

    if params[:rta_dependent_no] !~ /\D/  # returns true if all numbers
      rta_dependent_no = params[:rta_dependent_no].to_i
    else
      rta_dependent_no = params[:rta_dependent_no].in_numbers
    end

    rta_gross_income = params[:rta_gross_income]
    rta_gross_income = rta_gross_income.gsub(/[^0-9\.]/, '').to_i

    if rta_gross_income !~ /\D/
      rta_gross_income = rta_gross_income.to_i
    else
      if rta_gross_income.include?("dollars")
        rta_gross_income.slice!"dollars"
      end
      rta_gross_income = rta_gross_income.in_numbers
    end

    if  rta_gross_income.present? && rta_dependent_no.present?
         rta_eligibility = RtaFreeRide.find_by({ :rta_dependent_no => rta_dependent_no })

       p "rta_gross_income = #{rta_gross_income}"
       p "rta_eligibility.rta_gross_income = #{rta_eligibility.rta_gross_income}"

       if rta_gross_income < rta_eligibility.rta_gross_income
         @eligible = true
       else
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

     transportation = []
     ServiceCenter.all.each do |center|
       if center.description.match("transportation")
         transportation.push(center)
       end
     end


     @pb_zipcode = @user_zipcode.chomp(".0")
       @transportation_resources = transportation
       @transportation_resources_zip = []

       transportation.each do |center|
         if center.zip.match(@pb_zipcode)
           @transportation_resources_zip.push(center)
         end
       end


       #@transportation_resources.where(:zip => @user_zipcode)

         #in this case there are 2 medical centers in the user's zip
         if @transportation_resources_zip.count >= 2
            @transportation_resources = @transportation_resources_zip
         end

         #in this case there is 1 medical center in the user's zip
         if @transportation_resources_zip.count == 1
            @transportation_resources_first = @transportation_resources_zip.first
            @transportation_resources_second = @transportation_resources.first
         end

         #in this caser there are no medical centers in the user's zip
         if  @transportation_resources_zip.count == 0
             @transportation_resources_first = @transportation_resources.first
             @transportation_resources_second = @transportation_resources.second
         end

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rta_free_ride
      @rta_free_ride = RtaFreeRide.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rta_free_ride_params
      params.require(:rta_free_ride).permit(:rta_dependent_no, :rta_gross_income)
    end
end
