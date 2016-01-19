class SnapEligibilitiesController < ApplicationController

  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  before_action :set_snap_eligibility, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token



  def new
    @snap_eligibility = SnapEligibility.new
    @current_user = current_user
    if params[:data].present? 
      @d = SnapEligibilityData.new(JSON.parse(params[:data])) 
    else 
      @d = SnapEligibilityData.new
    end
  end

  def create
      @d = SnapEligibilityData.new
      @current_user = current_user
        dependent_no = params[:snap_dependent_no].strip
        # this is the words into numbers logic
        if dependent_no !~ /\D/  # returns true if all numbers
          @snap_dependent_no = dependent_no.to_i
          @d.dependent_no = @snap_dependent_no
        else
          @snap_dependent_no = dependent_no.in_numbers
          @d.dependent_no = @snap_dependent_no
        end

        @d.age = params[:age].strip
        @age = @d.age
        # if age !~ /\D/
        #   @age = age.to_i
        #   @d.age = @age
        # else
        #   @age = age.in_numbers
        #   @d.age = @age
        # end

        @snap_gross_income = params[:snap_gross_income].strip
        if @snap_gross_income !~ /\D/
          @snap_gross_income = @snap_gross_income.to_i
          @d.monthly_gross_income = @snap_gross_income
        else
          if @snap_gross_income.include?("dollars")
            @snap_gross_income.slice!"dollars"
          end
          @snap_gross_income = @snap_gross_income.in_numbers
          @d.monthly_gross_income = @snap_gross_income
        end

      if params[:disabled] != 'No'
        @disabled = true
      end

        # Data storage
        @d.user_location = params[:user_location]
        @d.phone_number = params[:phone_number] if params[:phone_number].present?
        @d.enrolled_in_education = params[:education]
        @d.citizen = params[:citizen]
        @d.disabled_status = params[:disabled]
        @d.zipcode = params[:zipcode]
        @d.student_status = params[:student]
        @d.work_status = params[:work]
        @d.amount_in_account = params[:amount_in_account]

        @d_json = @d.attributes.to_json

          # user is not a student
          if params[:education]  == 'no'
             if  @disabled == true
                @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
             elsif @age == "no"
               @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @snap_dependent_no })
             elsif @age == "yes"
               @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
             end
             if @snap_gross_income < @snap_eligibility.snap_gross_income
               @eligible = "yes"
               @d.snap_eligibility_status = @eligible
               #200 for seniors and elderly
               #20 for everyone else
             elsif @age == "yes" && (@snap_gross_income < @snap_eligibility.snap_gross_income + 200)
              @income_range = 200
              @eligible = "maybe"
              @hundred_dollar_range = true

             elsif @disabled == true && (@snap_gross_income < @snap_eligibility.snap_gross_income + 2000)
              @income_range = 200
              @eligible = "maybe"
              @hundred_dollar_range = true

             elsif @snap_gross_income < @snap_eligibility.snap_gross_income + 20
              @income_range = 20
              @eligible = "maybe"
              @hundred_dollar_range = true

             else
               @eligible = "no"
                @d.snap_eligibility_status = @eligible
             end

          # user is a student and citizen
          elsif params[:education]  == 'yes' && params[:citizen] == 'yes'
            if params[:student] == 'I am currently enrolled half time or more'
              if params[:work] == 'yes'
                if  @disabled == true
                   @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
                elsif @age == "no"
                  @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @snap_dependent_no })
                elsif @age == "yes"
                  @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
                end
                if @snap_gross_income < @snap_eligibility.snap_gross_income
                  @eligible = "yes"
                  @eligible_student = "yes"
                else
                  @eligible = "no"
                   @eligible_student = "no"
                 end
              # user is not working at least 20 hours
              else
                @eligible = "maybe"
                @eligible_student = "maybe"
              end
            # user is not enrolled at least part time
            else
              @eligible = "no"
              @eligible_student = "no"
            end
            @d.snap_eligibility_status = @eligible
          end

          #user is not a citizen
          if params[:citizen] == 'no'
            @eligible = 'maybe'
            @d.snap_eligibility_status = @eligible
          end

          # if @age.to_i < 18
          #   @eligible = "no"
          #   @d.snap_eligibility_status = @eligible
          # end

          if @snap_gross_income < 150 && params[:amount_in_account] == "yes"
            @expedited = true
          end

          @user_zipcode = params[:zipcode]
          @zipcode = @user_zipcode << ".0"
          @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

          if @lafcenter.present?
          else
            @lafcenter = LafCenter.find_by(:center => "King Community Service Center")
            @laf_disclaimer = "We do not have an estimation of the nearest center that is in range for you at this time. But we recommend going to the center below."
            @laf_disclaimer_spanish =  "En este momento no tenemos información sobre el centro que le queda más cerca, pero le recomendamos que vaya al siguiente centro: "
          end

          #this is the logic for the community resources
          @user_zipcode = @user_zipcode.chomp(".0")
          @resources = ServiceCenter.where(:description => "food pantry")
          @resources_zip = @resources.where(:zip => @user_zipcode)

            #in this case there are 2 food pantries in the user's zip
            if @resources_zip.count >= 2
               @resources = @resources_zip
            end

            #in this case there is 1 food pantry in the user's zip
            if @resources_zip.count == 1
               @resources_first = @resources_zip.first
               @resources_second = @resources.first
            end

            #in this caser there are no food pantries in the user's zip
            if  @resources_zip.count == 0
                @resources_first = @resources.first
                @resources_second = @resources.second
            end


        if params[:citizen].present? && params[:disabled].present? && params[:education] == "no"
          @d.save
        elsif params[:citizen].present? && params[:disabled].present? && params[:education] == "yes" && params[:student].present? && params[:work].present?
          @d.save
        else
           flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
          render "new"
        end

      def print
        @snap_data = SnapEligibilityData.find(params[:id])

        if @snap_data.disabled_status != "No"
           @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
        elsif @snap_data.age  == "no"
          @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @snap_dependent_no })
        elsif @snap_data.age == "yes"
          @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
        end
      end

    end


    def documents

    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_snap_eligibility
      @snap_eligibility = SnapEligibility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def snap_eligibility_params
      params.require(:snap_eligibility).permit(:snap_dependent_no, :snap_gross_income)
    end
end
