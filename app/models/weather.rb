class Weather
  attr_accessor :make_actual_call
  attr_reader :forecast

  def self.find(params)
    places =
      if !params[:places].blank?
        params[:places]
      elsif params[:locations].to_s == 'all'
        LatitudeLongitudeByRegion.instance.all_places
      else
        ['hood canal', 'teanaway', 'seattle', 'north casacdes',
         'paradise mt rainier', 'glacier peak', 'leavenworth',
         'snowqualmie pass', 'easton']
      end

    lat_long = LatitudeLongitudeByRegion.instance.convert(places)

    self.new(self.make_fake_call(params), lat_long)
  end

  def get_forecast
    @client.get_forecast if @client
  end

  def self.find_by_region(params)
    places = if !params[:places].blank?
               params[:places]
             elsif params[:locations].to_s == 'all'
               LatitudeLongitudeByRegion.instance.all_places
             else
               [:hood_canal, :teanaway]
             end

    lat_long = LatitudeLongitudeByRegion.instance.convert(places)

    new(make_fake_call(params), lat_long)
  end

  #######
  private
  #######
  def self.make_fake_call(params)
    if(params[:test].blank? && !Rails.env.production?)
      # in non prod by default we will make FAKE service calls
      true
    else
      (params[:test].to_s == 'true')
    end
  end

  def initialize(make_fake_call, lat_long)
    @make_actual_call = !make_fake_call
    @client = Forecast::Client::Base.new_client(@make_actual_call, lat_long)
  end

end

