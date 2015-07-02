class RidersController < ApplicationController
  before_action :set_rider, only: [:show, :edit, :update, :destroy]

  # GET /riders
  # GET /riders.json
  def index
    @riders = Rider.all
  end

  # GET /riders/1
  # GET /riders/1.json
  def show
  end

  # GET /riders/new
  def new
    @rider = Rider.new
  end

  # GET /riders/1/edit
  def edit
  end

  # POST /riders
  # POST /riders.json
  def create
    @rider = Rider.new(rider_params)

    respond_to do |format|
      if @rider.save
        format.html { redirect_to @rider, notice: 'Rider was successfully created.' }
        format.json { render :show, status: :created, location: @rider }
      else
        format.html { render :new }
        format.json { render json: @rider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /riders/1
  # PATCH/PUT /riders/1.json
  def update
    respond_to do |format|
      if @rider.update(rider_params)
        format.html { redirect_to @rider, notice: 'Rider was successfully updated.' }
        format.json { render :show, status: :ok, location: @rider }
      else
        format.html { render :edit }
        format.json { render json: @rider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /riders/1
  # DELETE /riders/1.json
  def destroy
    @rider.destroy
    respond_to do |format|
      format.html { redirect_to riders_url, notice: 'Rider was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def driver_search
    @rider = Rider.new(rider_params)
    #render :json => @rider[:sourcelat]
     require 'pg'
     conn = PGconn.open(:dbname => 'carpool1_0_2_development')
     count = Driver.count
     i =2

     #temp = {}
     #while i <= count
      # xyz = "SELECT * FROM drivers WHERE id = "+i.to_s
       #drivetemp = conn.exec(xyz)
       #temp[drivetemp]=1
    #   d = haversine(@rider["sourcelat"],@rider.sourcelong,drivetemp.sourcelat,drivetemp.sourcelong) * 1.6096
    #   if d< 2
       #@rider = conn.exec('SELECT * FROM Rider WHERE id = count')
    #conn.exec('create extension cube')
    #conn.exec('create extension earthdistance')
    query='select d.email,d.sourcelat,d.sourcelong,d.deslat,d.deslong,u.mobilenumber,u.name from drivers d,users u where d.email=u.email and d.email in (select email from drivers where earth_box(ll_to_earth(' + @rider.deslat.to_s + ',' + @rider.deslong.to_s + '), 1000) @> ll_to_earth(drivers.deslat,drivers.deslong) and earth_box(ll_to_earth(' + @rider.sourcelat.to_s + ',' + @rider.sourcelong.to_s + '), 1000) @> ll_to_earth(drivers.sourcelat,drivers.sourcelong));'
    temp = conn.exec(query)
      #render :json => drivetemp
      #file=[]
      #temp = Driver.all
      #t = 1
      #temp.each{|x| file.insert(-1,(User.find_by(email: x[:email])))}
       t ={}
        t["details"] = temp
    #end
    render :json => t
    # end
  end
  def time_diff
    @rider = Rider.new(rider_params)
    require 'time_diff'
    time_diff_components = Time.diff('03:59:00', '02:00:00')
    time_diff_hour = time_diff_components[:hour] + (time_diff_components[:minute]/60.0)
    render :json => time_diff_hour
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rider
      @rider = Rider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rider_params
      params.permit(:email, :time, :sourcelat, :sourcelong, :deslat, :deslong)
    end
end
