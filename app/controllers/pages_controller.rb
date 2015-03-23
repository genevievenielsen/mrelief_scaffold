class PagesController < ApplicationController
   skip_before_filter :verify_authenticity_token
  def homepage

  end

  def filtered_programs
    # CHICAGO PROGRAMS
    @programs = []

    # food stamps logic, based on household size, age, disability status and gross monthly income
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

    # rta ride free logic, based on age and disability status
    if params[:age].to_i > 64 || params[:disabled] != "No"
      @rta_ride_free = Program.find_by(:name_en => "RTA Ride Free")
      @programs.push(@rta_ride_free)
    end

    # all kids - householdsize and gross monthly income - slighlty more complicated because we ask how many children


    # medicaid - householdsize and gross monthly income
    @medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => params[:dependent_no].to_i})
    if params[:gross_income].to_i < @medicaid_eligibility.medicaid_gross_income
      @medicaid = Program.find_by(:name_en => "Medicaid")
      @programs.push(@medicaid)
    end

    # medicare cost sharing - householdsize and gross monthly income
    @medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => params[:dependent_no].to_i })
    if params[:gross_income].to_i < @medicare_sharing_eligibility.premium_only
      @medicare_cost_sharing = Program.find_by(:name_en => "Medicare Cost Sharing")
      @programs.push(@medicare_cost_sharing)
    end


    # programs that we can't screen for with global questions - rental assistance (90 day gross income),
    #aabd cash assistance, tanf cash assistance


    # ILLINOIS PROGRAMS

    # child care vouchers - householdsize and gross monthly income

    # wic - household size and gross monthly income

    # early head start - household size and gross monthly income

    # head start - household size


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
