require 'pry'
class Weather
  attr_accessor :make_actual_call
  attr_reader :forecast

  def self.find(params)
    places =
      if !params[:places].blank?
        params[:places].split ','
      elsif params[:locations].to_s == 'all'
        LatitudeLongitudeByRegion.instance.all_places
      else
        ['hood canal', 'teanaway', 'seattle', 'north casacdes',
         'paradise mt rainier', 'glacier peak', 'leavenworth',
         'snowqualmie pass', 'easton']
      end

    lat_long = LatitudeLongitudeByRegion.instance.convert(places)

    self.new(make_fake_call(params), lat_long, client_type(params))
  end

  def self.find_by_region(params)
    places = if !params[:places].blank?
               params[:places]
             elsif params[:locations].to_s == 'all'
               [LatitudeLongitudeByRegion.instance.all_places.sample]
               LatitudeLongitudeByRegion.instance.all_places
             else
               [:hood_canal, :teanaway]
             end

    lat_long = LatitudeLongitudeByRegion.instance.convert(places)

    type = client_type(params)
    self.new(make_fake_call(params), lat_long, type)
  end

  def get_forecast
    if @client
      responses, errors = @client.get_forecast
      # FIXME : set parser via Dependency Injection
      forecast = case @type
                 when DARK_SKY_CLIENT, DS_MOCK_CLIENT
                   Forecast::Parser.dark_sky_parser(responses, errors)
                 when VC_CLIENT, VC_MOCK_CLIENT
                   Forecast::VcParser.parse(responses, errors)
                 end
      return forecast
    end
  end


  #######
  private
  #######
  DARK_SKY_CLIENT = 'DARK_SKY_CLIENT'
  VC_CLIENT       = 'VC_CLIENT'
  DS_MOCK_CLIENT  = 'DS_MOCK_CLIENT'
  VC_MOCK_CLIENT  = 'VC_MOCK_CLIENT'

  def self.client_type(params)
    type = params['client_type']
    type ||= DARK_SKY_CLIENT
  end

  def self.make_fake_call(params)
    if(params[:test].blank? && !Rails.env.production?)
      # in non prod by default we will make FAKE service calls
      true
    else
      (params[:test].to_s == 'true')
    end
  end

  def initialize(make_fake_call, lat_long, type)
    @make_actual_call = !make_fake_call
    @type = type
    Rails.logger.debug "client is " + type
    @client =
      case type
      when DARK_SKY_CLIENT
        Forecast::Client::Base.
          new_ds_client(lat_long)
      when VC_CLIENT
        Forecast::Client::Base.
          new_vc_client(lat_long)
      when DS_MOCK_CLIENT
        Forecast::Client::Base.
          new_ds_mock_client(lat_long)
      when VC_MOCK_CLIENT
        Forecast::Client::Base.
          new_vc_mock_client(lat_long)
      end

  end

end

