class Weather
  attr_accessor :call_weather_client
  attr_reader :forecast
  def initialize(places = [])
    @call_weather_client = false

    places = ['hood canal', 'teanaway', 'seattle', 'north casacdes',
      'paradise mt rainier', 'glacier peak', 'leavenworth',
      'snowqualmie pass', 'easton']
    lat_long = LatitudeLongitude.instance.convert(places)
    @client = Forecast::Client.new lat_long
  end

  def self.all(call_weather_client)
    w = self.new
    w.call_weather_client = call_weather_client

    w
  end

  def get_forecast
    @client.get_forecast(@call_weather_client)
  end

end

