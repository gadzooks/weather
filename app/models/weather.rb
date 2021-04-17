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

  def get_forecast
    if @client
      responses, errors = @client.get_forecast
      forecast = case @type
                 when DARK_SKY_CLIENT
                   Forecast::Parser.dark_sky_parser(responses, errors)
                 else
                   Forecast::VcParser.parse(responses, errors)
                 end
      return forecast
    end
  end

  def self.find_by_region(params)
    places = if !params[:places].blank?
               params[:places]
             elsif params[:locations].to_s == 'all'
               LatitudeLongitudeByRegion.instance.all_places
               # ['seattle']
             else
               [:hood_canal, :teanaway]
             end

    lat_long = LatitudeLongitudeByRegion.instance.convert(places)

    Rails.logger.info "lat_long is " + places.inspect
    Rails.logger.info "lat_long is " + lat_long.inspect
    self.new(make_fake_call(params), lat_long, client_type(params))
  end

  #######
  private
  #######
  DARK_SKY_CLIENT = 'DARK_SKY_CLIENT'
  VC_CLIENT = 'VC_CLIENT'
  MOCK_CLIENT = 'MOCK_CLIENT'

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

  def initialize(make_fake_call, lat_long, type = DARK_SKY_CLIENT)
    @make_actual_call = !make_fake_call
    @type = type
    Rails.logger.info "client is " + type
    @client =
      case type
      when DARK_SKY_CLIENT
        Forecast::Client::Base.
          new_ds_client(lat_long)
      when VC_CLIENT
        Forecast::Client::Base.
          new_vc_client(lat_long)
      when MOCK_CLIENT
        Forecast::Client::Base.
          new_mock_client(lat_long)
      end

    Rails.logger.info "client is " + @client.inspect
  end

end

