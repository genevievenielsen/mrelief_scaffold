    class TanifsController < ApplicationController
  before_action :set_tanif, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token

  # GET /tanifs/new
  def new
    @tanif = Tanif.new
  end



  # POST /tanifs
  # POST /tanifs.json
  def create
    @tanif = Tanif.new

    if params[:household_size] !~ /\D/  # returns true if all numbers
      household_size = params[:household_size].to_i
    else
      household_size = params[:household_size].in_numbers
    end

    if params[:children] !~ /\D/  # returns true if all numbers
      children = params[:children].to_i
    else
      children = params[:children].in_numbers
    end

    gross_income = params[:gross_income]
    gross_income = gross_income.gsub(/[^0-9\.]/, '')

    if gross_income !~ /\D/
      gross_income = gross_income.to_i
    else
      if gross_income.include?("dollars")
        gross_income.slice!"dollars"
      end
      gross_income = gross_income.in_numbers
    end

    expect_child_support = params[:expect_child_support]
    expect_child_support = expect_child_support.gsub(/[^0-9\.]/, '')

    if expect_child_support !~ /\D/
      expect_child_support = expect_child_support.to_i
    else
      if expect_child_support.include?("dollars")
        expect_child_support.slice!"dollars"
      end
      expect_child_support = expect_child_support.in_numbers
    end

    expect_ssi = params[:expect_ssi]
    expect_ssi = expect_ssi.gsub(/[^0-9\.]/, '')

    if expect_ssi !~ /\D/
      expect_ssi = expect_ssi.to_i
    else
      if expect_ssi.include?("dollars")
        expect_ssi.slice!"dollars"
      end
      expect_ssi = expect_ssi.in_numbers
    end



  if params[:child] == "no"
      @eligible_tanif = "no"
  else
    if params[:relationship] == "adult_relative"
      @eligible_tanif = "maybe"
    else
      if params[:first] == "yes"
        household_size == 1
      end
      if params[:tanif_sixty_months] == "yes"
        @eligible_tanif = "no"
      else
        if children < household_size - 1
          @eligible_tanif = "maybe"
         else
           tanif_eligibility = Tanif.find_by({ :household_size => household_size })
           reduced_gross_income = gross_income * 0.75
           child_support = expect_child_support - 50
           total_income = reduced_gross_income + child_support
           if total_income > tanif_eligibility.max_income
            @eligible_tanif = "no"
           else
              if params[:anticipate_income] == "yes"
                @eligible_tanif = "maybe"
              else
                # child_support = expect_child_support - 50
                # child_support = gross_income + child_support
                # if child_support > tanif_eligibility.max_income
                #   @eligible_tanif = "no"
                #  else
                  if params[:teen_parent] == "yes"
                    @eligible_tanif = "maybe"
                  else
                    if params[:citizen] == "no"
                      @eligible_tanif = "maybe"
                    else

                      if params[:highschool] == "no" && household_size == 2
                        @eligible_tanif = "no"
                      elsif params[:highschool] == "no" && household_size > 2
                        @eligible_tanif = "maybe"
                      else
                        @eligible_tanif = "yes"
                      end

                    end
                  end
                 # end
              end
           end
        end
      end
    end
  end

     if params[:citizen] == "no"
        @eligible_tanif = "maybe"
    end

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
