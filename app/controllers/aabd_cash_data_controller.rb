class AabdCashDataController < ApplicationController
  before_action :set_aabd_cash_datum, only: [:show, :edit, :update, :destroy]

  # GET /aabd_cash_data
  # GET /aabd_cash_data.json
  def index
    @aabd_cash_data = AabdCashDatum.all
  end

  # GET /aabd_cash_data/1
  # GET /aabd_cash_data/1.json
  def show
  end

  # GET /aabd_cash_data/new
  def new
    @aabd_cash_datum = AabdCashDatum.new
  end

  # GET /aabd_cash_data/1/edit
  def edit
  end

  # POST /aabd_cash_data
  # POST /aabd_cash_data.json
  def create
    @aabd_cash_datum = AabdCashDatum.new(aabd_cash_datum_params)

    respond_to do |format|
      if @aabd_cash_datum.save
        format.html { redirect_to @aabd_cash_datum, notice: 'Aabd cash datum was successfully created.' }
        format.json { render :show, status: :created, location: @aabd_cash_datum }
      else
        format.html { render :new }
        format.json { render json: @aabd_cash_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aabd_cash_data/1
  # PATCH/PUT /aabd_cash_data/1.json
  def update
    respond_to do |format|
      if @aabd_cash_datum.update(aabd_cash_datum_params)
        format.html { redirect_to @aabd_cash_datum, notice: 'Aabd cash datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @aabd_cash_datum }
      else
        format.html { render :edit }
        format.json { render json: @aabd_cash_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aabd_cash_data/1
  # DELETE /aabd_cash_data/1.json
  def destroy
    @aabd_cash_datum.destroy
    respond_to do |format|
      format.html { redirect_to aabd_cash_data_url, notice: 'Aabd cash datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aabd_cash_datum
      @aabd_cash_datum = AabdCashDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aabd_cash_datum_params
      params.require(:aabd_cash_datum).permit(:household_size, :age, :thirty_day_net_income, :government_benefits, :assets, :citizen, :disabled_status, :zipcode, :aabd_eligibility_status)
    end
end
