class PagesController < ApplicationController
   skip_before_filter :verify_authenticity_token
  def homepage

  end

  def filtered_programs
    # CHICAGO PROGRAMS
    @programs = []

    if params[:food_stamps].present?
    else
      # Food Stamps logic, based on household size, age, disability status and gross monthly income
      if  params[:disabled] != "No"
         @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => params[:dependent_no].to_i})
      elsif params[:age].to_i <= 59
        @snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => params[:dependent_no].to_i })
      elsif params[:age].to_i > 59
        @snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => params[:dependent_no].to_i})
      end

      if params[:gross_income].to_i < @snap_eligibility.snap_gross_income
        @snap = Program.find_by(:name_en => "Food Stamps")
        @programs.push(@snap)
      end
    end

    if params[:rta_ride_free].present?
    else
      # RTA Ride Free logic, based on age and disability status
      if params[:age].to_i > 64 || params[:disabled] != "No"
        @rta_ride_free = Program.find_by(:name_en => "RTA Ride Free")
        @programs.push(@rta_ride_free)
      end
    end

    if params[:medicaid].present?
    else
      # Medicaid logic, based on household size and gross monthly income
      @medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => params[:dependent_no].to_i})
      if params[:gross_income].to_i < @medicaid_eligibility.medicaid_gross_income
        @medicaid = Program.find_by(:name_en => "Medicaid")
        @programs.push(@medicaid)
      end
    end

    if params[:medicare_cost_sharing].present?
    else
      # Medicare Cost Sharing logic, based on household size and gross monthly income
      @medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => params[:dependent_no].to_i })
      if params[:gross_income].to_i < @medicare_sharing_eligibility.premium_only
        @medicare_cost_sharing = Program.find_by(:name_en => "Medicare Cost Sharing")
        @programs.push(@medicare_cost_sharing)
      end
    end

    if params[:all_kids].present?
    else
      # all kids - householdsize and gross monthly income
      if params[:dependent_no].to_i > 1
        number_of_kids = params[:dependent_no].to_i - 1
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
      @ccdf_eligibility = ChildCareVoucher.find_by({ :ccdf_dependent_no => params[:dependent_no].to_i})
      if params[:gross_income].to_i < @ccdf_eligibility.ccdf_gross_income
        @child_care = Program.find_by(:name_en => "Child Care Voucher")
        @illinois_programs.push(@child_care)
      end
    end

    if params[:wic].present?
    else
      # wic - household size and gross monthly income
      @wic_eligibility = Wic.find_by({ :wic_household_size => params[:dependent_no].to_i })
      if params[:gross_income].to_i < @wic_eligibility.wic_gross_income
        @wic = Program.find_by(:name_en => "Women, Infants and Children (WIC)")
        @illinois_programs.push(@wic)
      end
    end

    if params[:early_head_start].present?
    else
      # early head start - household size and gross monthly income
      @ehs_eligibility = EarlyHeadStart.find_by({ :ehs_dependent_no => params[:dependent_no].to_i })
      if params[:gross_income].to_i< @ehs_eligibility.ehs_gross_income
        @ehs = Program.find_by(:name_en => "Early Head Start")
        @illinois_programs.push(@ehs)
      end
    end

    if params[:head_start].present?
    else
      # head start - household size
      if params[:dependent_no].to_i > 1
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
