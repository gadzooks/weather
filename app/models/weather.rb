class Weather
  PLACES = ['hood canal', 'teanaway', 'seattle', 'north casacdes',
            'paradise mt rainier', 'glacier peak', 'leavenworth',
            'snowqualmie pass', 'easton']

  attr_accessor :make_actual_call
  attr_reader :forecast
  def initialize(places)
    @make_actual_call = false

    lat_long = LatitudeLongitude.instance.convert(places)
    @client = Forecast::Client.new lat_long
  end

  def self.all(make_actual_call)
    w = self.new(PLACES)
    w.make_actual_call = make_actual_call
    w
  end

  def get_forecast
    @client.get_forecast(@make_actual_call)
  end

end

