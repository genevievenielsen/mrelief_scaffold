class HeadStartsController < ApplicationController
  before_action :set_head_start, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token


  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later


  def new
    @head_start = HeadStart.new
  end

  def create
     # if the params hash contains a letter
    if params[:hs_dependent_no] !~ /\D/  # returns true if all numbers
      hs_dependent_no = params[:hs_dependent_no].to_i
    else
      hs_dependent_no = params[:hs_dependent_no].in_numbers
    end

    hs_gross_income = params[:hs_gross_income]
    hs_gross_income = hs_gross_income.gsub(/[^0-9\.]/, '').to_i

    if hs_gross_income !~ /\D/
      hs_gross_income = hs_gross_income.to_i
    else
      if hs_gross_income.include?("dollars")
        hs_gross_income.slice!"dollars"
      end
      hs_gross_income = hs_gross_income.in_numbers
    end


    if  hs_gross_income.present? && hs_dependent_no.present?

    hs_eligibility = HeadStart.find_by({ :hs_dependent_no => hs_dependent_no })


       p "hs_gross_income = #{hs_gross_income}"
       p "hs_eligibility.hs_gross_income = #{hs_eligibility.hs_gross_income}"

       if hs_gross_income < hs_eligibility.hs_gross_income
         if params[:child_birthdate]  == "yes"
            @eligible = true
          end
       else

      end
    end #closes if statement

    @user_zipcode = params[:zipcode]
    @zipcode = @user_zipcode << ".0"
    @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

     headstart = []
     ServiceCenter.all.each do |center|
       if center.description.match("head start")
         headstart.push(center)
       end
     end


     @pb_zipcode = @user_zipcode.chomp(".0")
       @headstart_resources = headstart
       @headstart_resources_zip = []

       headstart.each do |center|
         if center.zip.match(@pb_zipcode)
           @headstart_resources_zip.push(center)
         end
       end


       #@headstart_resources.where(:zip => @user_zipcode)

         #in this case there are 2 medical centers in the user's zip
         if @headstart_resources_zip.count >= 2
            @headstart_resources = @headstart_resources_zip
         end

         #in this case there is 1 medical center in the user's zip
         if @headstart_resources_zip.count == 1
            @headstart_resources_first = @headstart_resources_zip.first
            @headstart_resources_second = @headstart_resources.first
         end

         #in this caser there are no medical centers in the user's zip
         if  @headstart_resources_zip.count == 0
             @headstart_resources_first = @headstart_resources.first
             @headstart_resources_second = @headstart_resources.second
         end

  end #closes end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_head_start
      @head_start = HeadStart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def head_start_params
      params.require(:head_start).permit(:hs_dependent_no, :hs_gross_income)
    end
end
