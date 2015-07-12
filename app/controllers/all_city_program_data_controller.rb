class AllCityProgramDataController < ApplicationController
  before_action :set_all_city_program_datum, only: [:show, :edit, :update, :destroy]


  def index
    @all_city_program_data = AllCityProgramDatum.all
  end

  # GET /all_city_program_data/1
  # GET /all_city_program_data/1.json
  def show
  end

  # GET /all_city_program_data/new
  def new
    @all_city_program_datum = AllCityProgramDatum.new
  end

  # GET /all_city_program_data/1/edit
  def edit
  end

  # POST /all_city_program_data
  # POST /all_city_program_data.json
  def create
    @all_city_program_datum = AllCityProgramDatum.new(all_city_program_datum_params)

    respond_to do |format|
      if @all_city_program_datum.save
        format.html { redirect_to @all_city_program_datum, notice: 'All city program datum was successfully created.' }
        format.json { render :show, status: :created, location: @all_city_program_datum }
      else
        format.html { render :new }
        format.json { render json: @all_city_program_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /all_city_program_data/1
  # PATCH/PUT /all_city_program_data/1.json
  def update
    respond_to do |format|
      if @all_city_program_datum.update(all_city_program_datum_params)
        format.html { redirect_to @all_city_program_datum, notice: 'All city program datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @all_city_program_datum }
      else
        format.html { render :edit }
        format.json { render json: @all_city_program_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /all_city_program_data/1
  # DELETE /all_city_program_data/1.json
  def destroy
    @all_city_program_datum.destroy
    respond_to do |format|
      format.html { redirect_to all_city_program_data_url, notice: 'All city program datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_all_city_program_datum
      @all_city_program_datum = AllCityProgramDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def all_city_program_datum_params
      params.require(:all_city_program_datum).permit(:dependent_no, :medicare_household_size, :age, :monthly_gross_income, :child_support, :ssi, :monthly_benefits, :ninety_day_gross_income, :annual_gross_income, :assets, :number_of_children, :enrolled_in_education, :citizen, :zipcode, :disabled_status, :name_on_lease, :rental_status, :pregnant, :child_health_insurance_state, :pregnant_or_caring_for_child, :relationship_to_child, :pregnant_with_first_child, :tanif_sixty_months, :anticipate_other_income, :teen_parent, :child_in_school, :snap_eligibility_status, :all_kids_eligibility_status, :rta_eligibility_status, :medicaid_eligibility_status, :medicare_cost_sharing_eligibility_status, :rental_eligibility_status, :aabd_eligibility_status, :tanf_eligibility_status)
    end
end
