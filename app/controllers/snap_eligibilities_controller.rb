  class SnapEligibilitiesController < ApplicationController

  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  before_action :set_snap_eligibility, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, :only => :index
  skip_before_filter :verify_authenticity_token


  def new
    @snap_eligibility = SnapEligibility.new
    @s = SnapEligibilityData.new
  end

  def new2
    @snap_eligibility = SnapEligibility.new
    @s = SnapEligibilityData.new
  end

  def create
    @s = SnapEligibilityData.new
    # this is the words into numbers logic
    if params[:snap_dependent_no] !~ /\D/  # returns true if all numbers
      @snap_dependent_no = params[:snap_dependent_no].to_i
      @s.dependent_no = @snap_dependent_no
    else
      @snap_dependent_no = params[:snap_dependent_no].in_numbers
      @s.dependent_no = @snap_dependent_no
    end

    if params[:age] !~ /\D/
      @age = params[:age].to_i
      @s.age = @age
    else
      @age = params[:age].in_numbers
      @s.age = @age
    end

    @snap_gross_income = params[:snap_gross_income]
    @snap_gross_income = @snap_gross_income.gsub(/[^0-9\.]/, '')

    if @snap_gross_income !~ /\D/
      @snap_gross_income = @snap_gross_income.to_i
      @s.monthly_gross_income = @snap_gross_income
    else
      if @snap_gross_income.include?("dollars")
        @snap_gross_income.slice!"dollars"
      end
      @snap_gross_income = @snap_gross_income.in_numbers
      @s.monthly_gross_income = @snap_gross_income
    end

    if params[:disabled] != 'No'
      @disabled = true
    end

      # Data storage
      @s.user_location = params[:user_location]
      @s.phone_number = params[:phone_number] if params[:phone_number].present?
      @s.enrolled_in_education = params[:education]
      @s.citizen = params[:citizen]
      @s.disabled_status = params[:disabled]
      @s.zipcode = params[:zipcode]
      @s.student_status = params[:student]
      @s.work_status = params[:work]

        if params[:education]  == 'no' && params[:citizen] == 'yes'
           if  @disabled == true
              @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
           elsif @age <= 59
             @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @snap_dependent_no })
           elsif @age > 59
             @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
           end
           if @snap_gross_income < @snap_eligibility.snap_gross_income
             @eligible = "yes"
             @s.snap_eligibility_status = @eligible
           else
             @eligible = "no"
              @s.snap_eligibility_status = @eligible
           end

        # user is a student and citizen
        elsif params[:education]  == 'yes' && params[:citizen] == 'yes'
          if params[:student_status] == 'I am currently enrolled half time or more'
            if params[:work_status] == 'yes'
              if  @disabled == true
                 @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
              elsif @age <= 59
                @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @snap_dependent_no })
              elsif @age > 59
                @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
              end
              if @snap_gross_income < @snap_eligibility.snap_gross_income
                @eligible = "yes"
              else
                @eligible = "no"
               end
            # user is not working at least 20 hours
            else
              @eligible = "maybe"
            end
          # user is not enrolled at least part time
          else
            @eligible = "no"
          end
          @s.snap_eligibility_status = @eligible

        elsif params[:citizen] == 'no'
          @eligible = 'maybe'
          @s.snap_eligibility_status = @eligible
        end

        if @age < 18
          @eligible = "no"
          @s.snap_eligibility_status = @eligible
        end

        @user_zipcode = params[:zipcode]
        @zipcode = @user_zipcode << ".0"
        @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

        if @lafcenter.present?
        else
          @lafcenter = LafCenter.find_by(:id => 10)
          @laf_disclaimer = "We do not have an estimation of the nearest center that is in range for you at this time. But we recommend going to the center below."
        end

        #this is the logic for the community resources
        @user_zipcode = @user_zipcode.chomp(".0")
        @food_resources = ServiceCenter.where(:description => "food pantry")
        @food_resources_zip = @food_resources.where(:zip => @user_zipcode)

          #in this case there are 2 food pantries in the user's zip
          if @food_resources_zip.count >= 2
             @food_resources = @food_resources_zip
          end

          #in this case there is 1 food pantry in the user's zip
          if @food_resources_zip.count == 1
             @food_resources_first = @food_resources_zip.first
             @food_resources_second = @food_resources.first
          end

          #in this caser there are no food pantries in the user's zip
          if  @food_resources_zip.count == 0
              @food_resources_first = @food_resources.first
              @food_resources_second = @food_resources.second
          end
      @s.save

      if params[:citizen].present? && params[:disabled].present? && params[:education].present?
      else
         flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
        render "new"
      end

      if params[:education] == "yes"
        if params[:student].present? && params[:work].present?
        else
          flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
          render "new"
        end
      end
  end

  def create2
    @s = SnapEligibilityData.new
    # this is the words into numbers logic
    if params[:snap_dependent_no] !~ /\D/  # returns true if all numbers
      @snap_dependent_no = params[:snap_dependent_no].to_i
      @s.dependent_no = @snap_dependent_no
    else
      @snap_dependent_no = params[:snap_dependent_no].in_numbers
      @s.dependent_no = @snap_dependent_no
    end

    if params[:age] !~ /\D/
      @age = params[:age].to_i
      @s.age = @age
    else
      @age = params[:age].in_numbers
      @s.age = @age
    end

    @snap_gross_income = params[:snap_gross_income]
    @snap_gross_income = @snap_gross_income.gsub(/[^0-9\.]/, '')

    if @snap_gross_income !~ /\D/
      @snap_gross_income = @snap_gross_income.to_i
      @s.monthly_gross_income = @snap_gross_income
    else
      if @snap_gross_income.include?("dollars")
        @snap_gross_income.slice!"dollars"
      end
      @snap_gross_income = @snap_gross_income.in_numbers
      @s.monthly_gross_income = @snap_gross_income
    end

    if params[:disabled] != 'No'
      @disabled = true
    end

      # Data storage
      @s.user_location = params[:user_location]
      @s.phone_number = params[:phone_number] if params[:phone_number].present?
      @s.enrolled_in_education = params[:education]
      @s.citizen = params[:citizen]
      @s.disabled_status = params[:disabled]
      @s.zipcode = params[:zipcode]
      @s.student_status = params[:student]
      @s.work_status = params[:work]

        if params[:education]  == 'no' && params[:citizen] == 'yes'
           if  @disabled == true
              @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
           elsif @age <= 59
             @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @snap_dependent_no })
           elsif @age > 59
             @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
           end
           if @snap_gross_income < @snap_eligibility.snap_gross_income
             @eligible = "yes"
             @s.snap_eligibility_status = @eligible
           else
             @eligible = "no"
              @s.snap_eligibility_status = @eligible
           end

        # user is a student and citizen
        elsif params[:education]  == 'yes' && params[:citizen] == 'yes'
          if params[:student_status] == 'I am currently enrolled half time or more'
            if params[:work_status] == 'yes'
              if  @disabled == true
                 @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
              elsif @age <= 59
                @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @snap_dependent_no })
              elsif @age > 59
                @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @snap_dependent_no})
              end
              if @snap_gross_income < @snap_eligibility.snap_gross_income
                @eligible = "yes"
              else
                @eligible = "no"
               end
            # user is not working at least 20 hours
            else
              @eligible = "maybe"
            end
          # user is not enrolled at least part time
          else
            @eligible = "no"
          end
          @s.snap_eligibility_status = @eligible

        elsif params[:citizen] == 'no'
          @eligible = 'maybe'
          @s.snap_eligibility_status = @eligible
        end

        if @age < 18
          @eligible = "no"
          @s.snap_eligibility_status = @eligible
        end

        @user_zipcode = params[:zipcode]
        @zipcode = @user_zipcode << ".0"
        @lafcenter = LafCenter.find_by(:zipcode => @zipcode)

        if @lafcenter.present?
        else
          @lafcenter = LafCenter.find_by(:id => 10)
          @laf_disclaimer = "We do not have an estimation of the nearest center that is in range for you at this time. But we recommend going to the center below."
        end

        #this is the logic for the community resources
        @user_zipcode = @user_zipcode.chomp(".0")
        @food_resources = ServiceCenter.where(:description => "food pantry")
        @food_resources_zip = @food_resources.where(:zip => @user_zipcode)

          #in this case there are 2 food pantries in the user's zip
          if @food_resources_zip.count >= 2
             @food_resources = @food_resources_zip
          end

          #in this case there is 1 food pantry in the user's zip
          if @food_resources_zip.count == 1
             @food_resources_first = @food_resources_zip.first
             @food_resources_second = @food_resources.first
          end

          #in this caser there are no food pantries in the user's zip
          if  @food_resources_zip.count == 0
              @food_resources_first = @food_resources.first
              @food_resources_second = @food_resources.second
          end
      @s.save

      if params[:citizen].present? && params[:disabled].present? && params[:education].present?
      else
         flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
        render "new"
      end

      if params[:education] == "yes"
        if params[:student].present? && params[:work].present?
        else
          flash.now[:alert] = 'Looks like you forgot to answer a question! Please answer all questions below.'
          render "new"
        end
      end
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
