class Weather
  DEFAULT_PLACES = ['hood canal', 'teanaway', 'seattle', 'north casacdes',
                    'paradise mt rainier', 'glacier peak', 'leavenworth',
                    'snowqualmie pass', 'easton']

  attr_accessor :make_actual_call
  attr_reader :forecast

  def self.all(params)
    make_fake_call =
      if(params[:test].blank? && !Rails.env.production?)
        # in non prod by default we will make FAKE service calls
        true
      else
        (params[:test].to_s == 'true')
      end

    places = params[:places] || DEFAULT_PLACES

    self.new(make_fake_call, places)
  end

  def get_forecast
    @client.get_forecast if @client
  end

  #######
  private
  #######

  def initialize(make_fake_call, places)
    @make_actual_call = !make_fake_call

    lat_long = LatitudeLongitude.instance.convert(places)
    @client = Forecast::Client::Base.new_client(@make_actual_call, lat_long)
  end

end

