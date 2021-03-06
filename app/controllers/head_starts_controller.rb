class HeadStartsController < ApplicationController
  before_action :set_head_start, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token


  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later


  def new
    @head_start = HeadStart.new
    if params[:data].present? 
      @d = HeadStartData.new(JSON.parse(params[:data])) 
    else 
      @d = HeadStartData.new
    end
    @current_user = current_user
  end

  def create
    @d = HeadStartData.new
     # if the params hash contains a letter
    if params[:hs_dependent_no] !~ /\D/  # returns true if all numbers
      hs_dependent_no = params[:hs_dependent_no].to_i
      @d.dependent_no = hs_dependent_no
    else
      hs_dependent_no = params[:hs_dependent_no].in_numbers
      @d.dependent_no = hs_dependent_no
    end

    hs_gross_income = params[:hs_gross_income]
    hs_gross_income = hs_gross_income.gsub(/[^0-9\.]/, '').to_i

    if hs_gross_income !~ /\D/
      hs_gross_income = hs_gross_income.to_i
      @d.gross_annual_income = hs_gross_income
    else
      if hs_gross_income.include?("dollars")
        hs_gross_income.slice!"dollars"
      end
      hs_gross_income = hs_gross_income.in_numbers
      @d.gross_annual_income = hs_gross_income
    end

    if  hs_gross_income.present? && hs_dependent_no.present?

       hs_eligibility = HeadStart.find_by({ :hs_dependent_no => hs_dependent_no })

       if hs_gross_income < hs_eligibility.hs_gross_income
         if params[:child_birthdate]  == "yes"
            @eligible = true
            @d.eligibility_status = "yes"
          else
            @d.eligibility_status = "no"
          end
       else
        @d.eligibility_status = "no"
      end
    end #closes if statement

    @user_zipcode = params[:zipcode]
    @zipcode = @user_zipcode << ".0"
    @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

    if @lafcenter.present?
    else
      @lafcenter = LafCenter.find_by(:id => 10)
    end

     headstart = []
     ServiceCenter.all.each do |center|
       if center.description.match("head start")
         headstart.push(center)
       end
     end

     @pb_zipcode = @user_zipcode.chomp(".0")
       @resources = headstart
       @resources_zip = []

       headstart.each do |center|
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

    @d.user_location = params[:user_location]
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.child_birthdate = params[:child_birthdate]
    @d.zipcode = @user_zipcode.chop.chop
    @d.save
    @d_json = @d.attributes.to_json


    if params[:child_birthdate].present?
    else
       flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
      render "new"
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
