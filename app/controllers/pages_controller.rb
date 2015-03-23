class PagesController < ApplicationController
   skip_before_filter :verify_authenticity_token
  def homepage

  end

  def filtered_programs
    @programs = []

    # if the user is older than 64 OR disabled, show the rta ride free program
    if params[:age].to_i > 64 || params[:disabled] != "No"
      @rta_ride_free = Program.find_by(:name_en => "RTA Ride Free")
      @programs.push(@rta_ride_free)
    end

    # all kids - householdsize and gross monthly income

    # medicaid - householdsize and gross monthly income

    # medicare cost sharing - householdsize and gross monthly income

    # programs that we can't screen for with global questions - rental assistance,

     # @programs = Program.all
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
