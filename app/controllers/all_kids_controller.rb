class AllKidsController < ApplicationController
  before_action :set_all_kid, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token


  # GET /all_kids/new
  def new
    @all_kid = AllKid.new
    if params[:data].present? 
      @d = AllKidsData.new(JSON.parse(params[:data])) 
    else 
      @d = AllKidsData.new
    end

    @current_user = current_user
  end

  # POST /all_kids
  # POST /all_kids.json
  def create
    @d = AllKidsData.new
    # if the params hash contains a letter
    if params[:kids_household_size] !~ /\D/  # returns true if all numbers
      kids_household_size = params[:kids_household_size].to_i
      @d.household_size = kids_household_size
    else
      kids_household_size = params[:kids_household_size].in_numbers
      @d.household_size = kids_household_size
    end

    kids_gross_income = params[:kids_gross_income]
    kids_gross_income = kids_gross_income.gsub(/[^0-9\.]/, '').to_i
    if kids_gross_income !~ /\D/
      kids_gross_income = kids_gross_income.to_i
      @d.monthly_gross_income = kids_gross_income
    else
      if kids_gross_income.include?("dollars")
        kids_gross_income.slice!"dollars"
      end
      kids_gross_income = kids_gross_income.in_numbers
      @d.monthly_gross_income = kids_gross_income
    end

    if params[:pregnant] == 'yes'
      kids_household_size = kids_household_size + 1
    end

    if kids_gross_income.present? && kids_household_size.present?
      kids_eligibility = AllKid.find_by({ :kids_household_size => kids_household_size })
      p "kids_gross_income = #{kids_gross_income}"

       if kids_gross_income < kids_eligibility.premium_1_gross_income
         @eligible = true
         @d.allkids_eligibility_status = "yes"
       end

       if @eligible ==  true
        # now find out which version they are eligible for
        if kids_gross_income <= kids_eligibility.assist_gross_income
          @assist_eligible = true
          @d.assist_eligibility = "yes"
        elsif kids_gross_income <= kids_eligibility.share_gross_income && kids_gross_income > kids_eligibility.assist_gross_income
          @share_eligible = true
          @d.share_eligibility = "yes"
        elsif kids_gross_income <= kids_eligibility.premium_1_gross_income && kids_gross_income > kids_eligibility.share_gross_income
          @premium1_eligible = true
          @d.premium1_eligibility = "yes"
        end
       end

        #this is the logic for premium 2
        if kids_gross_income <= kids_eligibility.premium_2_gross_income && kids_gross_income > kids_eligibility.premium_1_gross_income
          if params["status"] == 'none'
             @eligible = false
             @d.allkids_eligibility_status = "no"
          else
            @eligible = true
            @premium2_eligible = true
            @d.allkids_eligibility_status = "yes"
            @d.premium2_eligibility = "yes"
          end
        end

        if kids_gross_income > kids_eligibility.premium_2_gross_income
          @eligible = false
          @d.allkids_eligibility_status = "no"
        end

        if kids_household_size == 1
          @eligible = false
          @d.allkids_eligibility_status = "no"
        end
    end

    # Health care status variable
    @healthcare_status = ""
    if params[:uninsured].present?
      @healthcare_status = @healthcare_status + "uninsured, " 
      puts @healthcare_status
    end
    if params[:job_ended].present?
      @healthcare_status = @healthcare_status + "job_ended, "
      puts @healthcare_status
    end
    if params[:cobra].present?
      @healthcare_status = @healthcare_status + "cobra, "
      puts @healthcare_status
    end
    if params[:status] == "none"
      @healthcare_status = @healthcare_status + "none"
      puts @healthcare_status
    end
    
  
    # Data Storage
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.user_location = params[:user_location]
    @d.pregnant = params[:pregnant]
    @d.healthcare_status = @healthcare_status
    @d.zipcode = params[:zipcode]
    @d.save

    @d_json = @d.attributes.to_json

    @user_zipcode = params[:zipcode]
    @zipcode = @user_zipcode << ".0"
    @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

    if @lafcenter.present?
    else
      @lafcenter = LafCenter.find_by(:center => "King Community Service Center")
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
      if params[:pregnant].present?
        if params[:uninsured].present? || params[:job_ended].present? || params[:cobra].present? || params[:status].present?
        else
           flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
          render "new"
        end
      else
         flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
        render "new"
      end

  end



  # DELETE /all_kids/1
  # DELETE /all_kids/1.json
  def destroy
    @all_kid.destroy
    respond_to do |format|
      format.html { redirect_to all_kids_url, notice: 'All kid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_all_kid
      @all_kid = AllKid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def all_kid_params
      params.require(:all_kid).permit(:kids_household_size, :assist_gross_income, :share_gross_income, :premium_1_gross_income, :premium_2_gross_income)
    end
end
