class PagesController < ApplicationController
  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

   skip_before_filter :verify_authenticity_token
  def homepage
    if current_user.present?
      @current_user = current_user
    end
  end

  def filtered_programs



    # Clean data
    dependent_no = params[:dependent_no].strip
    if dependent_no !~ /\D/  # returns true if all numbers
      @dependent_no = dependent_no.to_i
    else
      @dependent_no = dependent_no.in_numbers
    end

    age = params[:age].strip
    if age !~ /\D/
      @age = age.to_i
    else
      @age = age.in_numbers
    end

    gross_income = params[:gross_income].strip
    if gross_income.include?("$")
      gross_income.slice!"$"
    end
    if gross_income.include?("dollars")
      gross_income.slice!"dollars"
      gross_income.strip
    end
    if gross_income.include?(".")
      gross_income = gross_income.split(".")
      gross_income = gross_income[0]
    end
    if gross_income !~ /\D/
      @gross_income = gross_income.to_i
    else
      @gross_income = gross_income.in_numbers
    end

     # Check that all questions are answered
    if params[:benefits].present? && params[:disabled].present? && params[:dependent_no].present? && params[:age].present? && params[:gross_income].present?
    else
      redirect_to :back, :notice => 'Looks like you forgot to answer a question! Please answer all questions below.'

    end

    #User data Storage
    if current_user.present?
      @user = @current_user
    else
      @user = User.new
    end
    @user.age = @age
    @user.household_size = @dependent_no
    @user.gross_income = @gross_income
    @user.disability_benefits = params[:disabled]
    @user.benefits = params[:benefits]
    @user.save

    #session hash
    session[:user_id] = @user.id

    # CHICAGO PROGRAMS
    @programs = []

    if params[:food_stamps].present?
    else
      # Food Stamps logic, based on household size, age, disability status and gross monthly income
      if  params[:disabled] != "No"
         @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @dependent_no})
      elsif @age <= 59
        @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => @dependent_no})
      elsif @age > 59
        @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => @dependent_no})
      end

      if params[:gross_income].to_i < @snap_eligibility.snap_gross_income
        @snap = Program.find_by(:name_en => "Food Stamps")
        @programs.push(@snap)
      end
    end

    if params[:rta_ride_free].present?
    else
      # RTA Ride Free logic, based on age and disability status
      if @age > 64 || params[:disabled] != "No"
        @rta_ride_free = Program.find_by(:name_en => "RTA Ride Free")
        @programs.push(@rta_ride_free)
      end
    end

    if params[:medicaid].present?
    else
      # Medicaid logic, based on household size and gross monthly income
      @medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => @dependent_no})
      if params[:gross_income].to_i < @medicaid_eligibility.medicaid_gross_income
        @medicaid = Program.find_by(:name_en => "Medicaid")
        @programs.push(@medicaid)
      end
    end

    if params[:medicare_cost_sharing].present?
    else
      # Medicare Cost Sharing logic, based on household size and gross monthly income
      @medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => @dependent_no})
      if params[:gross_income].to_i < @medicare_sharing_eligibility.premium_only
        @medicare_cost_sharing = Program.find_by(:name_en => "Medicare Cost Sharing")
        @programs.push(@medicare_cost_sharing)
      end
    end

    if params[:all_kids].present?
    else
      # all kids - householdsize and gross monthly income
      if @dependent_no > 1
        number_of_kids = @dependent_no - 1
        @kids_eligibility = AllKid.find_by({ :kids_household_size => number_of_kids })
        if params[:gross_income].to_i < @kids_eligibility.premium_1_gross_income
          @all_kids = Program.find_by(:name_en => "All Kids")
          @programs.push(@all_kids)
        end
      end
    end

    # programs that we can't screen for with global questions - rental assistance (90 day gross income),
    #aabd cash assistance, tanf cash assistance


    # ILLINOIS PROGRAMS
    @illinois_programs = []

    if params[:child_care_vouchers].present?
    else
      # child care vouchers - householdsize and gross monthly income
      @ccdf_eligibility = ChildCareVoucher.find_by({ :ccdf_dependent_no => @dependent_no})
      if params[:gross_income].to_i < @ccdf_eligibility.ccdf_gross_income
        @child_care = Program.find_by(:name_en => "Child Care Voucher")
        @illinois_programs.push(@child_care)
      end
    end

    if params[:wic].present?
    else
      # wic - household size and gross monthly income
      @wic_eligibility = Wic.find_by({ :wic_household_size => @dependent_no})
      if params[:gross_income].to_i < @wic_eligibility.wic_gross_income
        @wic = Program.find_by(:name_en => "Women, Infants and Children (WIC)")
        @illinois_programs.push(@wic)
      end
    end

    if params[:early_head_start].present?
    else
      # early head start - household size and gross monthly income
      @ehs_eligibility = EarlyHeadStart.find_by({ :ehs_dependent_no => @dependent_no})
      if params[:gross_income].to_i< @ehs_eligibility.ehs_gross_income
        @ehs = Program.find_by(:name_en => "Early Head Start")
        @illinois_programs.push(@ehs)
      end
    end

    if params[:head_start].present?
    else
      # head start - household size
      if @dependent_no > 1
        @head_start = Program.find_by(:name_en => "Head Start")
        @illinois_programs.push(@head_start)
      end
    end

  end

  def about_us
  end

  def contact_us
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    advertising = params[:advertising]
    feedback = params[:feedback]

  end

  def how_mrelief_works
  end

  def press_release
  end

end
