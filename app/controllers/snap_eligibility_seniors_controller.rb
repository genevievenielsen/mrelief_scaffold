class SnapEligibilitySeniorsController < ApplicationController
  before_action :set_snap_eligibility_senior, only: [:show, :edit, :update, :destroy]

  # GET /snap_eligibility_seniors
  # GET /snap_eligibility_seniors.json
  def index
    @snap_eligibility_seniors = SnapEligibilitySenior.all
  end

  # GET /snap_eligibility_seniors/1
  # GET /snap_eligibility_seniors/1.json
  def show
  end

  # GET /snap_eligibility_seniors/new
  def new
    @snap_eligibility_senior = SnapEligibilitySenior.new
  end

  # GET /snap_eligibility_seniors/1/edit
  def edit
  end

  # POST /snap_eligibility_seniors
  # POST /snap_eligibility_seniors.json
  def create
    @snap_eligibility_senior = SnapEligibilitySenior.new(snap_eligibility_senior_params)

    respond_to do |format|
      if @snap_eligibility_senior.save
        format.html { redirect_to @snap_eligibility_senior, notice: 'Snap eligibility senior was successfully created.' }
        format.json { render :show, status: :created, location: @snap_eligibility_senior }
      else
        format.html { render :new }
        format.json { render json: @snap_eligibility_senior.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /snap_eligibility_seniors/1
  # PATCH/PUT /snap_eligibility_seniors/1.json
  def update
    respond_to do |format|
      if @snap_eligibility_senior.update(snap_eligibility_senior_params)
        format.html { redirect_to @snap_eligibility_senior, notice: 'Snap eligibility senior was successfully updated.' }
        format.json { render :show, status: :ok, location: @snap_eligibility_senior }
      else
        format.html { render :edit }
        format.json { render json: @snap_eligibility_senior.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snap_eligibility_seniors/1
  # DELETE /snap_eligibility_seniors/1.json
  def destroy
    @snap_eligibility_senior.destroy
    respond_to do |format|
      format.html { redirect_to snap_eligibility_seniors_url, notice: 'Snap eligibility senior was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_snap_eligibility_senior
      @snap_eligibility_senior = SnapEligibilitySenior.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def snap_eligibility_senior_params
      params.require(:snap_eligibility_senior).permit(:snap_dependent_no, :snap_gross_income)
    end
end
