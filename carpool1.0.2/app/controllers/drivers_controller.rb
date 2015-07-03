class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :edit, :update, :destroy]

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)
    i = Driver.count
    @driver.driverid = i+1

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def gcm
    app = Rpush::Gcm::App.new
    app.name = "Maps"
    app.auth_key = "AIzaSyBEkWSAmgqumH7hxvzk_V-grkfgamgv-TY"
    app.connections = 1
    app.save!

    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name("Maps")
    n.registration_ids = ["eZjKxcoUnDI:APA91bF5cD3Fq9kCjaqXw6p4em4vON8kJ8TpgIdKY-bOSX2ltFOmDwM_6mqO9pBHJuYoGEwx9F9JTrpZHpCR7ZsATlawFP7S5gpxFXq-sePOtWHjh9oBQ8bX7s3Ec1H2Y_Ojob_sdQQ0"]
    n.data = { message: "hi mom!" }
    n.save!
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.permit(:driverid,:email, :time, :sourcelat, :sourcelong, :deslat, :deslong)
    end
end
