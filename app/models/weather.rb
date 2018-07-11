class Weather
  def initialize(places = [])
    #places ||= ['seattle', 'hood canal', 'teanaway']
    places = ['seattle']

    lat_long = LatitudeLongitude.instance.convert(places)
    @client = Forecast::Client.new lat_long
  end

  def get_forecast
    @forecast = @client.get_forecast
  end

end

