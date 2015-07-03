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
     require 'pg'
     conn = PGconn.open(:dbname => 'carpool1_0_2_development')
     count = Driver.count
    query='select d.email,d.sourcelat,d.sourcelong,d.deslat,d.deslong,u.mobilenumber,u.name from drivers d,users u where d.email=u.email and d.driverid in (select driverid from drivers where earth_box(ll_to_earth(' + @rider.deslat.to_s + ',' + @rider.deslong.to_s + '), 1000) @> ll_to_earth(drivers.deslat,drivers.deslong) and earth_box(ll_to_earth(' + @rider.sourcelat.to_s + ',' + @rider.sourcelong.to_s + '), 1000) @> ll_to_earth(drivers.sourcelat,drivers.sourcelong));'
    temp = conn.exec(query)
       t ={}
        t["details"] = temp
    render :json => t
  end

  def driver_search_google_api
    @rider = Rider.new(rider_params)
     require 'pg'
     conn = PGconn.open(:dbname => 'carpool1_0_2_development')
     count = Driver.count
     t = {}
     #query_1 = '\set r_latitude ' + @rider.sourcelat.to_s + ';'
     #query_2 = '\set r_longitude ' + @rider.sourcelong.to_s + ';'
     #conn.exec(query_1)
     #conn.exec(query_2)
     temp=[]
     driver_source=conn.exec('select sourcelat , sourcelong, email, driverid, deslat ,deslong from drivers;')
     count=driver_source.count
     i = 0
     my_var=[]
     while i < count
      sourcedis =  google_dis_api(@rider.sourcelat.to_f,@rider.sourcelong.to_f,driver_source[i]["sourcelat"].to_f,driver_source[i]["sourcelong"].to_f)
      desdis =  google_dis_api(@rider.deslat.to_f,@rider.deslong.to_f,driver_source[i]["deslat"].to_f,driver_source[i]["deslong"].to_f)
      
      my_var.push(sourcedis,desdis)

      if sourcedis <=1.0 && desdis <=1.0
          query = 'select d.email,d.sourcelat,d.sourcelong,d.deslat,d.deslong,u.mobilenumber,u.name from drivers d,users u where d.email=u.email and d.driverid = ' + driver_source[i]["driverid"].to_s + ';'
          temp1 = conn.exec(query)
          temp.push(temp1)
          #my_var.push(query)
      end
      
      i = i+1
     end 

     #query = 'select d.email,d.sourcelat,d.sourcelong,d.deslat,d.deslong,u.mobilenumber,u.name from drivers d,users u where d.email=u.email and d.email in (select email from drivers where' + google_dis_api(@rider.sourcelat,@rider.sourcelong,driver_source[0],driver_source[1]) ' < ' + 2.to_s');'
     #temp = temp + conn.exec(query)
     t = {}
     t["details"] = temp
     render :json => my_var
  end

  def google_dis_api(riderlat,riderlong,driverlat,driverlong)
    #@rider = Rider.new(rider_params)
    require 'net/http'

    result = Net::HTTP.get(URI.parse('https://maps.googleapis.com/maps/api/distancematrix/json?origins= ' + riderlat.to_s + ',' + riderlong.to_s + '&destinations=' + driverlat.to_s + ',' + driverlong.to_s ))

    require 'json'
    x = JSON.parse(result)
    #render :json => x
     #d=[]
     #d=  x["rows"][0]["elements"][0]["distance"]["text"].to_f
    if x["rows"][0]["elements"][0]["status"]=="OK"
     return x["rows"][0]["elements"][0]["distance"]["text"].to_f
    else
     return nil
    end
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
