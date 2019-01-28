class Weather
  DEFAULT_PLACES = ['hood canal', 'teanaway', 'seattle', 'north casacdes',
                    'paradise mt rainier', 'glacier peak', 'leavenworth',
                    'snowqualmie pass', 'easton']

  attr_accessor :make_actual_call
  attr_reader :forecast

  def self.find(params)
    places =
      if !params[:places].blank?
        params[:places]
      elsif params[:locations].to_s == 'all'
        LatitudeLongitude.instance.all_places
      else
        Weather::DEFAULT_PLACES
      end

    make_fake_call =
      if(params[:test].blank? && !Rails.env.production?)
        # in non prod by default we will make FAKE service calls
        true
      else
        (params[:test].to_s == 'true')
      end

    lat_long = LatitudeLongitude.instance.convert(places)

    self.new(make_fake_call, lat_long)
  end

  def get_forecast
    @client.get_forecast if @client
  end

  #######
  private
  #######

  def initialize(make_fake_call, lat_long)
    @make_actual_call = !make_fake_call
    @client = Forecast::Client::Base.new_client(@make_actual_call, lat_long)
  end

end

