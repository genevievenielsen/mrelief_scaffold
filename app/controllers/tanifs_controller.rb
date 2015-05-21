    class TanifsController < ApplicationController
  before_action :set_tanif, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /tanifs/new
  def new
    @tanif = Tanif.new
    @d = TanfData.new
  end

  # POST /tanifs
  # POST /tanifs.json
  def create
    @d = TanfData.new

    if params[:household_size] !~ /\D/  # returns true if all numbers
      household_size = params[:household_size].to_i
      @d.household_size = household_size
    else
      household_size = params[:household_size].in_numbers
      @d.household_size = household_size
    end

    if params[:children] !~ /\D/  # returns true if all numbers
      children = params[:children].to_i
      @d.children = children
    else
      children = params[:children].in_numbers
      @d.children = children
    end

    gross_income = params[:gross_income]
    gross_income = gross_income.gsub(/[^0-9\.]/, '')
    if gross_income !~ /\D/
      gross_income = gross_income.to_i
      @d.thirty_day_gross_income = gross_income
    else
      if gross_income.include?("dollars")
        gross_income.slice!"dollars"
      end
      gross_income = gross_income.in_numbers
      @d.thirty_day_gross_income = gross_income
    end

    expect_child_support = params[:expect_child_support]
    expect_child_support = expect_child_support.gsub(/[^0-9\.]/, '')
    if expect_child_support !~ /\D/
      expect_child_support = expect_child_support.to_i
      @d.expect_child_support = expect_child_support
    else
      if expect_child_support.include?("dollars")
        expect_child_support.slice!"dollars"
      end
      expect_child_support = expect_child_support.in_numbers
      @d.expect_child_support = expect_child_support
    end

    expect_ssi = params[:expect_ssi]
    expect_ssi = expect_ssi.gsub(/[^0-9\.]/, '')
    if expect_ssi !~ /\D/
      expect_ssi = expect_ssi.to_i
      @d.expect_ssi = expect_ssi
    else
      if expect_ssi.include?("dollars")
        expect_ssi.slice!"dollars"
      end
      expect_ssi = expect_ssi.in_numbers
      @d.expect_ssi = expect_ssi
    end

  if params[:pregnant].present? || params[:care_for_child].present? || params[:first_child].present?
    if params[:relationship] == "adult relative"
      @eligible_tanif = "maybe"
      @d.tanf_eligibility_status = @eligible_tanif
    else
      if params[:first_child] == "first_child"
        household_size == 1
      end
      if params[:tanif_sixty_months] == "yes"
         @eligible_tanif = "no"
         @d.tanf_eligibility_status = @eligible_tanif
      else
        if children < household_size - 1
          @eligible_tanif = "maybe"
          @d.tanf_eligibility_status = @eligible_tanif
        else
          tanif_eligibility = Tanif.find_by({ :household_size => household_size })
          reduced_gross_income = gross_income * 0.75
          child_support = expect_child_support - 50
          total_income = reduced_gross_income + child_support
          if total_income > tanif_eligibility.max_income
            @eligible_tanif = "no"
            @d.tanf_eligibility_status = @eligible_tanif
          else
            if params[:anticipate_income] == "yes"
              @eligible_tanif = "maybe"
              @d.tanf_eligibility_status = @eligible_tanif
            else
              if params[:teen_parent] == "teen_parent"
                @eligible_tanif = "maybe"
                @d.tanf_eligibility_status = @eligible_tanif
              else
                if params[:citizen] == "no"
                  @eligible_tanif = "maybe"
                  @d.tanf_eligibility_status = @eligible_tanif
                else
                  if params[:highschool].present? && household_size == 2
                     @eligible_tanif = "no"
                     @d.tanf_eligibility_status = @eligible_tanif
                   elsif params[:highschool].present? && household_size > 2
                     @eligible_tanif = "maybe"
                     @d.tanf_eligibility_status = @eligible_tanif
                   else
                     @eligible_tanif = "yes"
                     @d.tanf_eligibility_status = @eligible_tanif
                   end
                end
              end
            end
          end
        end
      end
    end
  elsif params[:no_children].present?
    @eligible_tanif = "no"
    @d.tanf_eligibility_status = @eligible_tanif
  else
    @eligible_tanif = "no"
    @d.tanf_eligibility_status = @eligible_tanif
  end

   if params[:citizen] == "no"
     @eligible_tanif = "maybe"
     @d.tanf_eligibility_status = @eligible_tanif
  end

    # DATA STORAGE
    @d.user_location = params[:user_location]
    @d.phone_number = params[:phone_number] if params[:phone_number].present?
    @d.pregnant_or_caring_for_child = params[:care_for_child] || params[:pregant] || params[:no_children]
    @d.relationship_to_child = params[:relationship]
    @d.enrolled_in_high_school = params[:no_highschool]
    @d.teen_parent = params[:teen_parent]
    @d.pregnant_with_first_child = params[:first_child]
    @d.anticipate_other_income = params[:anticipate_income]
    @d.tanif_sixty_months = params[:tanif_sixty_months]
    @d.citizen = params[:citizen]
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

    if params[:relationship].present? && params[:tanif_sixty_months].present? && params[:anticipate_income].present? && params[:citizen].present?
    else
       flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
      render "new"
    end

  end


  # DELETE /tanifs/1
  # DELETE /tanifs/1.json
  def destroy
    @tanif.destroy
    respond_to do |format|
      format.html { redirect_to tanifs_url, notice: 'Tanif was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tanif
      @tanif = Tanif.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tanif_params
      params.require(:tanif).permit(:household_size, :earned_income, :tanif_payment, :max_income)
    end
end
