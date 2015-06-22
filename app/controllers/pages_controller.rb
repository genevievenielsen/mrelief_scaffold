class PagesController < ApplicationController
  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

   skip_before_filter :verify_authenticity_token

  def early_learning_programs
  end

  def homepage
  end

  def filter
    if current_user.present?
      @current_user = current_user
    end
  end

  def filtered_programs
    # Check that all questions are answered
    if params[:benefits].present? && params[:disabled].present? && params[:dependent_no].present? && params[:age].present? && params[:gross_income].present?
    else
      redirect_to :back, :alert => 'Looks like you forgot to answer a question! Please answer all questions below.'
    end
    
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

    #Data Storage
    if current_user.present?
      @current_user = current_user
    else
      @current_user = User.new
    end
    @current_user.age = @age
    @current_user.household_size = @dependent_no
    @current_user.gross_income = @gross_income
    @current_user.disability_benefits = params[:disabled]
    @current_user.benefits = params[:benefits]
    @current_user.food_stamps = params[:food_stamps]
    @current_user.rta_ride_free = params[:rta_ride_free]
    @current_user.rental_assistance = params[:rental_assistance]
    @current_user.medicaid = params[:medicaid]
    @current_user.medicare_cost_sharing = params[:medicare_cost_sharing]
    @current_user.all_kids = params[:all_kids]
    @current_user.child_care_vouchers = params[:child_care_vouchers]
    @current_user.early_head_start = params[:early_head_start]
    @current_user.head_start = params[:head_start]
    @current_user.aabd = params[:aabd]
    @current_user.tanf = params[:tanf]
    @current_user.save

    #session hash
    session[:user_id] = @current_user.id

    # CHICAGO PROGRAMS
    @programs = []
    @community_resources = []
    @ineligible_or_receiving_programs = []

    # @all_city = Program.find_by(:name_en => "All City Programs")
    # @programs.push(@all_city)

    @snap = Program.find_by(:name_en => "Food Stamps")
    if params[:food_stamps].present?
      # User is already receiving food stamps
      @community_resources.push("food")
      @ineligible_or_receiving_programs.push(@snap)
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
        @programs.push(@snap)
      else
        @community_resources.push("food")
      end
    end

    @rta_ride_free = Program.find_by(:name_en => "RTA Ride Free")
    if params[:rta_ride_free].present?
      @community_resources.push("transportation")
      @ineligible_or_receiving_programs.push(@rta_ride_free)
    else
      # RTA Ride Free logic, based on age and disability status
      if @age > 64 || params[:disabled] != "No"
        @programs.push(@rta_ride_free)
      else
        @community_resources.push("transportation")
        @ineligible_or_receiving_programs.push(@rta_ride_free)
      end
    end

    @medicaid = Program.find_by(:name_en => "Medicaid")
    if params[:medicaid].present?
      @community_resources.push("health")
      @ineligible_or_receiving_programs.push(@medicaid)
    else
      # Medicaid logic, based on household size and gross monthly income
      @medicaid_eligibility = Medicaid.find_by({ :medicaid_household_size => @dependent_no})
      if params[:gross_income].to_i < @medicaid_eligibility.medicaid_gross_income
        @programs.push(@medicaid)
      else
        @community_resources.push("health")
        @ineligible_or_receiving_programs.push(@medicaid)
      end
    end

    @medicare_cost_sharing = Program.find_by(:name_en => "Medicare Cost Sharing")
    if params[:medicare_cost_sharing].present?
      @community_resources.push("health")
      @ineligible_or_receiving_programs.push(@medicare_cost_sharing)
    else
      # Medicare Cost Sharing logic, based on household size and gross monthly income
      @medicare_sharing_eligibility = MedicareCostSharing.find_by({ :household_size => @dependent_no})
      if params[:gross_income].to_i < @medicare_sharing_eligibility.premium_only
        @programs.push(@medicare_cost_sharing)
      else
        @community_resources.push("health")
        @ineligible_or_receiving_programs.push(@medicare_cost_sharing)
      end
    end

    @all_kids = Program.find_by(:name_en => "All Kids")
    if params[:all_kids].present?
      @community_resources.push("health")
      @ineligible_or_receiving_programs.push(@all_kids)
    else
      # all kids - householdsize and gross monthly income
      if @dependent_no > 1
        number_of_kids = @dependent_no - 1
        @kids_eligibility = AllKid.find_by({ :kids_household_size => number_of_kids })
        if params[:gross_income].to_i < @kids_eligibility.premium_1_gross_income
          @programs.push(@all_kids)
        else
          @community_resources.push("health")
          @ineligible_or_receiving_programs.push(@all_kids)
        end
      end
    end

    @aabd = Program.find_by(:name_en => "AABD Cash Assistance")
    if params[:aabd].present?
      @community_resources.push("aging")
      @ineligible_or_receiving_programs.push(@aabd)
    else
      # AABD logic, based on age and disability status
      if @age > 64 || params[:disabled] != "No"
        @programs.push(@aabd)
      else
        @community_resources.push("aging")
        @ineligible_or_receiving_programs.push(@aabd)
      end
    end

    # programs that we can't screen for with global questions - rental assistance (90 day gross income),
    # tanf cash assistance
    @rental_assistance = Program.find_by(:name_en => "Rental Assistance")
    if params[:rental_assistance].present?
      @community_resources.push("housing")
      @ineligible_or_receiving_programs.push(@rental_assistance)
    else
      @programs.push(@rental_assistance)
    end


    @tanf = Program.find_by(:name_en => "TANF")
    if params[:tanf].present?
      @community_resources.push("child care")
      @ineligible_or_receiving_programs.push(@tanf)
    else
      @programs.push(@tanf)
    end


    # ILLINOIS PROGRAMS
    @illinois_programs = []

    @child_care = Program.find_by(:name_en => "Child Care Voucher")
    if params[:child_care_vouchers].present?
      @community_resources.push("child care")
      @ineligible_or_receiving_programs.push(@child_care)
    else
      # child care vouchers - householdsize and gross monthly income
      @ccdf_eligibility = ChildCareVoucher.find_by({ :ccdf_dependent_no => @dependent_no})
      if params[:gross_income].to_i < @ccdf_eligibility.ccdf_gross_income
        @illinois_programs.push(@child_care)
      else
        @community_resources.push("child care")
        @ineligible_or_receiving_programs.push(@child_care)
      end
    end

    @wic = Program.find_by(:name_en => "Women, Infants and Children (WIC)")
    if params[:wic].present?
      @community_resources.push("child care")
      @ineligible_or_receiving_programs.push(@wic)
    else
      # wic - household size and gross monthly income
      @wic_eligibility = Wic.find_by({ :wic_household_size => @dependent_no})
      if params[:gross_income].to_i < @wic_eligibility.wic_gross_income
        @illinois_programs.push(@wic)
      else
        @community_resources.push("child care")
        @ineligible_or_receiving_programs.push(@wic)
      end
    end

    @ehs = Program.find_by(:name_en => "Early Head Start")
    if params[:early_head_start].present?
      @community_resources.push("early head start")
      @ineligible_or_receiving_programs.push(@ehs)
    else
      # early head start - household size and gross monthly income
      @ehs_eligibility = EarlyHeadStart.find_by({ :ehs_dependent_no => @dependent_no})
      if params[:gross_income].to_i< @ehs_eligibility.ehs_gross_income
        @illinois_programs.push(@ehs)
      else
        @community_resources.push("early head start")
        @ineligible_or_receiving_programs.push(@ehs)
      end
    end

    @head_start = Program.find_by(:name_en => "Head Start")
    if params[:head_start].present?
      @community_resources.push("head start")
      @ineligible_or_receiving_programs.push(@head_start)
    else
      # head start - household size
      if @dependent_no > 1
        @illinois_programs.push(@head_start)
      else
        @community_resources.push("head start")
        @ineligible_or_receiving_programs.push(@head_start)
      end
    end

    # Just program name
    @ineligible_or_receiving_programs_names = []
    @ineligible_or_receiving_programs.each do |program|
      @ineligible_or_receiving_programs_names.push(program.name_en)
    end

    @all_programs = @programs + @illinois_programs
  end

  def community_resources

    @community_resources = params[:resources]
    @user_zipcode = params[:zipcode]

    # FOOD RESOURCES
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

    #TRANSPORATION RESOURCES
    transportation = []
    ServiceCenter.all.each do |center|
      if center.description.match("transportation")
        transportation.push(center)
      end
    end

    @transportation_resources = transportation
    @transportation_resources_zip = []
    transportation.each do |center|
      if center.zip.match(@user_zipcode)
        @transportation_resources_zip.push(center)
      end
    end
       #in this case there are 2 medical centers in the user's zip
       if @transportation_resources_zip.count >= 2
          @transportation_resources = @transportation_resources_zip
       end
       #in this case there is 1 medical center in the user's zip
       if @transportation_resources_zip.count == 1
          @transportation_resources_first = @transportation_resources_zip.first
          @transportation_resources_second = @transportation_resources.first
       end
       #in this caser there are no medical centers in the user's zip
       if  @transportation_resources_zip.count == 0
           @transportation_resources_first = @transportation_resources.first
           @transportation_resources_second = @transportation_resources.second
       end

    #HEALTH RESOURCES
    primarycare = []
    ServiceCenter.all.each do |center|
      if center.description.match("primary care")
        primarycare.push(center)
      end
    end
      @medical_resources = primarycare
      @medical_resources_zip = []
      primarycare.each do |center|
        if center.zip.match(@user_zipcode)
          @medical_resources_zip.push(center)
        end
      end
      #in this case there are 2 medical centers in the user's zip
      if @medical_resources_zip.count >= 2
         @medical_resources = @medical_resources_zip
      end
      #in this case there is 1 medical center in the user's zip
      if @medical_resources_zip.count == 1
         @medical_resources_first = @medical_resources_zip.first
         @medical_resources_second = @medical_resources.first
      end
      #in this caser there are no medical centers in the user's zip
      if  @medical_resources_zip.count == 0
          @medical_resources_first = @medical_resources.first
          @medical_resources_second = @medical_resources.second
      end

    #HOUSING RESOURCES
    housing = []
    ServiceCenter.all.each do |center|
      if center.description.match("housing")
        housing.push(center)
      end
    end
      @housing_resources = housing
      @housing_resources_zip = []
      housing.each do |center|
        if center.zip.match(@user_zipcode)
          @housing_resources_zip.push(center)
        end
      end
      #in this case there are 2 housing centers in the user's zip
      if @housing_resources_zip.count >= 2
         @housing_resources = @housing_resources_zip
      end
      #in this case there is 1 aabd center in the user's zip
      if @housing_resources_zip.count == 1
         @housing_resources_first = @housing_resources_zip.first
         @housing_resources_second = @housing_resources.first
      end
      #in this caser there are no aabd centers in the user's zip
      if  @housing_resources_zip.count == 0
          @housing_resources_first = @housing_resources.first
          @housing_resources_second = @housing_resources.second
      end

  aabd = []
  ServiceCenter.all.each do |center|
    if center.description.match("senior services")
      unless center.description.match("child care")
      aabd.push(center)
      end
    end
    if center.description.match("disabled")
      unless center.description.match("child care")
      aabd.push(center)
      end
    end
  end
    @aabd_resources = aabd
    @aabd_resources_zip = []
    aabd.each do |center|
      if center.zip.match(@user_zipcode)
        @aabd_resources_zip.push(center)
      end
    end
    #in this case there are 2 aabd centers in the user's zip
    if @aabd_resources_zip.count >= 2
       @aabd_resources = @aabd_resources_zip
    end
    #in this case there is 1 aabd center in the user's zip
    if @aabd_resources_zip.count == 1
       @aabd_resources_first = @aabd_resources_zip.first
       @aabd_resources_second = @aabd_resources.first
    end
    #in this caser there are no aabd centers in the user's zip
    if  @aabd_resources_zip.count == 0
        @aabd_resources_first = @aabd_resources.first
        @aabd_resources_second = @aabd_resources.second
    end

  #CHILD CARE RESOURCES
  childcare = []
  ServiceCenter.all.each do |center|
    if center.description.match("child care")
      childcare.push(center)
    end
  end

    @child_resources = childcare
    @child_resources_zip = []

    childcare.each do |center|
      if center.zip.match(@user_zipcode)
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

  #HEAD START RESOURCES
  headstart = []
  ServiceCenter.all.each do |center|
    if center.description.match("head start")
      headstart.push(center)
    end
  end

    @headstart_resources = headstart
    @headstart_resources_zip = []

    headstart.each do |center|
      if center.zip.match(@user_zipcode)
        @headstart_resources_zip.push(center)
      end
    end

   #in this case there are 2 medical centers in the user's zip
   if @headstart_resources_zip.count >= 2
      @headstart_resources = @headstart_resources_zip
   end
   #in this case there is 1 medical center in the user's zip
   if @headstart_resources_zip.count == 1
      @headstart_resources_first = @headstart_resources_zip.first
      @headstart_resources_second = @headstart_resources.first
   end
   #in this caser there are no medical centers in the user's zip
   if  @headstart_resources_zip.count == 0
       @headstart_resources_first = @headstart_resources.first
       @headstart_resources_second = @headstart_resources.second
   end

  #EARLY HEAD START
  earlyheadstart = []
  ServiceCenter.all.each do |center|
    if center.description.match("early head start")
      earlyheadstart.push(center)
    end
  end

    @earlyheadstart_resources = earlyheadstart
    @earlyheadstart_resources_zip = []

    earlyheadstart.each do |center|
      if center.zip.match(@user_zipcode)
        @earlyheadstart_resources_zip.push(center)
      end
    end

    #in this case there are 2 medical centers in the user's zip
    if @earlyheadstart_resources_zip.count >= 2
       @earlyheadstart_resources = @earlyheadstart_resources_zip
    end
    #in this case there is 1 medical center in the user's zip
    if @earlyheadstart_resources_zip.count == 1
       @earlyheadstart_resources_first = @earlyheadstart_resources_zip.first
       @earlyheadstart_resources_second = @earlyheadstart_resources.first
    end
    #in this caser there are no medical centers in the user's zip
    if  @earlyheadstart_resources_zip.count == 0
        @earlyheadstart_resources_first = @earlyheadstart_resources.first
        @earlyheadstart_resources_second = @earlyheadstart_resources.second
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

  def session_clear
    session[:user_id ] = nil
        session[:EsignDisclosureAccepted] = nil
       session[:AccountNo] = nil
       render :text => "session cleared"
  end



end
