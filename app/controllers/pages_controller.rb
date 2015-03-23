class PagesController < ApplicationController
   skip_before_filter :verify_authenticity_token
  def homepage

  end

  def filtered_programs
    # CHICAGO PROGRAMS
    @programs = []

    # food stamps logic
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

    # if the user is older than 64 OR disabled, show the rta ride free program
    if params[:age].to_i > 64 || params[:disabled] != "No"
      @rta_ride_free = Program.find_by(:name_en => "RTA Ride Free")
      @programs.push(@rta_ride_free)
    end

    # all kids - householdsize and gross monthly income

    # medicaid - householdsize and gross monthly income

    # medicare cost sharing - householdsize and gross monthly income

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
